import 'dart:io';
import 'dart:typed_data';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/data/model/add-category_request_dto.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/presentation/bloc/category_bloc.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/presentation/bloc/category_event.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/presentation/bloc/category_state.dart';
import '../../../../core/common/textform_field.dart';
import '../../../../core/constants/app_constant.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/common/photo_card.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    context.read<CategoryBloc>().add(FetchCategoryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Row(
          children: [
            Text("Category",style: GoogleFonts.inter(
                fontSize: 24,
                color: Colors.white
            ),),
            const Spacer(),

            ElevatedButton.icon(
              onPressed:(){
                showDialog(context: context, builder: (context) {
                  final _formKey = GlobalKey<FormState>();
                  TextEditingController _categoryNameController = TextEditingController(text: "Kacchi");
                  Uint8List? imageBytes;

                  return StatefulBuilder(
                    builder: (context,setState){
                      return AlertDialog(
                        backgroundColor: ColorConstants.cardBackgroundColor,
                        title: Center(child: Text("Category",style: Theme.of(context).textTheme.bodyMedium,)),
                        content: BlocConsumer<CategoryBloc, CategoryState>(
                          builder: (context,state) {

                            if (state is CategoryAddLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Container(
                              width: MediaQuery.sizeOf(context).width*0.4,
                              height: MediaQuery.sizeOf(context).height*0.5,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: ColorConstants.backgroundColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Form(
                                key: _formKey,
                                  child: ListView(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          PhotoCard(
                                            levelText: "Category",
                                            onImagePicked: (value) {
                                              imageBytes = value!;
                                            },
                                          ),
                                        ],
                                      ),
                                      CTextFormField(
                                          labelText: "Category Name",
                                          validatorText: "Category Name is required",
                                          textEditingController:_categoryNameController),
                                    ],

                              )),
                            );
                          }, listener: (BuildContext context, CategoryState state) {
                          if (state is CategoryAddSuccess) {
                            Navigator.pop(context);
                            ElegantNotification.success(
                              title:  const Text("Success",style: TextStyle(color: Colors.black),),
                              width: 300,
                              height: 100,
                              description:  Text(state.message,style: const TextStyle(color: Colors.black)),
                            ).show(context);
                          }
                          else if(state is CategoryAddFailure){
                            ElegantNotification.error(
                              title:  const Text("Error",style: TextStyle(color: Colors.black),),
                              description:  Text(state.error,style: const TextStyle(color: Colors.black,),maxLines: 2,overflow: TextOverflow.ellipsis,),
                              width: 300,
                              height: 100,
                            ).show(context);
                          }
                        },
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                ColorConstants.cardBackgroundColor),
                            child: Text(
                              "Cancel",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if(imageBytes != null ){
                                  context.read<CategoryBloc>().add(AddCategoryEvent(
                                  AddCategoryRequestDto(
                                    name: _categoryNameController.text,
                                    imageByte : imageBytes!
                                  )));

                                }else if(imageBytes == null){
                                  ElegantNotification.error(
                                    title:  const Text("Error",style: TextStyle(color: Colors.black),),
                                    description:  const Text("Please Select an Image",style: TextStyle(color: Colors.black,),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                    width: 300,
                                    height: 100,
                                  ).show(context);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstants.primaryColor),
                            child: Text(
                              "Create",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          )
                        ],
                      );
                    }
                  );
                },);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
                fixedSize: Size(140, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              label: Text("Add New",style: GoogleFonts.inter(
                  color: Colors.white,fontSize: 14
              )),
              icon: Icon(Icons.add,color: Colors.white,),
            ),
            const SizedBox(width: 20,),
            IconButton(onPressed: (){
              context.read<CategoryBloc>().add(FetchCategoryEvent());
            }, icon: const Icon(Icons.refresh,size: 30,color: Colors.white,),)

          ],
        ),
        const SizedBox(height: 20,),
        Expanded(
          child: BlocBuilder<CategoryBloc,CategoryState>(
            builder: (context,state) {

              if(state is CategoryFetchSuccess){
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorConstants.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("Image",style: Theme.of(context).textTheme.bodyMedium,)),
                        DataColumn(label: Text("Category Name",style: Theme.of(context).textTheme.bodyMedium,)),
                      ],
                      rows: [
                       ...state.categories.map((e) => DataRow(
                         cells: [
                           DataCell(
                             Container(
                               width: 40,
                               height: 40,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 image: DecorationImage(
                                   image: NetworkImage(e.image),
                                   fit: BoxFit.cover
                                 )
                               ),
                             ),
                           ),
                           DataCell(Text(e.name,style: Theme.of(context).textTheme.bodyMedium,)),
                         ]
                       )
                       )
                      ],

                    ),
                  ),


                );
              }else if(state is CategoryFetchLoading){
                return const Center(child: CircularProgressIndicator(),);
              }
              else if(state is CategoryFetchFailure){
                return Center(child: Text(state.error,style: Theme.of(context).textTheme.bodyMedium,));
              }else{
                return const SizedBox();
              }

            }
          ),
        )

      ],
    );
  }
}
