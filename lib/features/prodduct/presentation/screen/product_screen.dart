
import 'dart:typed_data';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kacchi_bari_admin_dashboard/core/common/textform_field.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/data/model/category_model.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/presentation/bloc/category_bloc.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/presentation/bloc/category_state.dart';
import 'package:kacchi_bari_admin_dashboard/features/prodduct/data/model/product_add_request_dto.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/app_constant.dart';
import '../../../../core/common/photo_card.dart';
import '../../../category/data/model/category_dropdown_item.dart';
import '../../../category/presentation/bloc/category_event.dart';
import '../../data/model/package_variation.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

@override
  void initState() {
  context.read<ProductBloc>().add(FetchProductEvent());
  context.read<CategoryBloc>().add(FetchCategoryEvent());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Food",style: GoogleFonts.inter(
                fontSize: 24,
                color: Colors.white
            ),),
            const Spacer(),
            ElevatedButton.icon(
              onPressed:(){
                showDialog(
                  context: context,
                  builder: (context) {
                    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                    Uint8List? imageBytes;
                    TextEditingController _name = TextEditingController();
                    TextEditingController _price = TextEditingController();
                    bool packageSwitchValue=false;
                    List<PackageVariation> variations = [];
                    List<TextEditingController> personCountControllers = [];
                    List<TextEditingController> priceControllers = [];


                    void addVariation(void Function(void Function()) setState) {
                      setState(() {
                        variations.add(PackageVariation(personCount: 2, price: 0));
                        personCountControllers.add(TextEditingController());
                        priceControllers.add(TextEditingController());
                      });
                    }
                    void removeVariation(void Function(void Function()) setState,int index) {
                      setState(() {
                        variations.removeAt(index);
                        personCountControllers[index].dispose();
                        priceControllers[index].dispose();
                        personCountControllers.removeAt(index);
                        priceControllers.removeAt(index);
                      });
                    }
                    CategoryDropdownItem? _selectedCategory;
                    return StatefulBuilder(
                    builder: (context,setState) {

                      return AlertDialog(
                        backgroundColor: ColorConstants.cardBackgroundColor,
                        title: Center(child: Text("Food",style: Theme.of(context).textTheme.bodyMedium,)),
                        content:  BlocConsumer<ProductBloc, ProductState>(
                          builder: (context,state) {
                            if (state is ProductAddLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Container(
                              width: MediaQuery.sizeOf(context).width*0.4,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: ColorConstants.backgroundColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child:Form(
                                key: _formKey,
                                child: ListView(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        PhotoCard(
                                          levelText: "Food",
                                          onImagePicked: (value) {
                                            imageBytes = value!;
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CTextFormField(
                                              labelText: "Enter Food Name",
                                              validatorText: "Please enter food name",
                                              textEditingController: _name,
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Expanded(
                                          child: CTextFormField(
                                            labelText: "Enter Price",
                                            validatorText: "Please enter food price",
                                            textEditingController: _price,
                                          ),
                                        )

                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child:  BlocBuilder<CategoryBloc, CategoryState>(
                                              builder: (context, state) {
                                                if (state is CategoryFetchLoading) {
                                                  return const Center(child: CircularProgressIndicator());
                                                } else if (state is CategoryFetchFailure) {
                                                  return Text('Error: ${state.error}');
                                                } else if (state is CategoryFetchSuccess) {
                                                  return DropdownButtonFormField<CategoryDropdownItem>(
                                                    dropdownColor: ColorConstants.cardBackgroundColor,
                                                    selectedItemBuilder: (BuildContext context) {
                                                      return state.categories.map((category) {
                                                        return Text(category.name.toString(),
                                                          style:  Theme.of(context).textTheme.bodyMedium,
                                                        );
                                                      }).toList();
                                                    },
                                                    items: state.categories.map((CategoryModel category) {
                                                      return DropdownMenuItem<CategoryDropdownItem>(
                                                        value:  CategoryDropdownItem(id: category.id, name: category.name),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            category.name.toString(),
                                                            style: Theme.of(context).textTheme.bodySmall,
                                                          )
                                                        ),
                                                      );
                                                    }).toList(),
                                                    value: _selectedCategory,
                                                    onChanged: ( category) {
                                                      setState(() {
                                                        _selectedCategory = category;
                                                      });
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return "Please select a Category";
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: ColorConstants.primaryColor),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: ColorConstants.primaryColor),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      errorBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.red),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: ColorConstants.primaryColor),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      labelText: 'Select a Category',
                                                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                                                    ),
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              },
                                            ),
                                        ),
                                        Expanded(
                                          child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Package", style: Theme.of(context).textTheme.bodyLarge,),
                                            const SizedBox(width: 15,),
                                            Switch.adaptive(
                                              value: packageSwitchValue,
                                              onChanged: (value) {
                                              setState(() {
                                                packageSwitchValue=value;
                                                if (!packageSwitchValue) {
                                                  variations.clear();
                                                  personCountControllers.clear();
                                                  priceControllers.clear();
                                                }
                                              });

                                            },
                                              activeColor: Colors.white,
                                              activeTrackColor: ColorConstants.primaryColor,
                                              inactiveThumbColor: Colors.red,

                                            )
                                          ],
                                        ),

                                        ),
                                        if (packageSwitchValue)
                                          IconButton(
                                            icon: const Icon(Icons.add,color: Colors.white,),
                                            onPressed: () => addVariation(setState),
                                          ),
                                      ],

                                    ),
                                    const SizedBox(height: 10,),
                                    ...variations.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: CTextFormField(
                                              labelText: "Person Count",
                                              validatorText: "Please enter person count",
                                              textEditingController: personCountControllers[index],
                                              onChanged: (value) {
                                                if (value.isNotEmpty) {
                                                  variations[index].personCount = int.parse(value);
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 20,),
                                          Expanded(
                                            child: CTextFormField(
                                              labelText: "Price",
                                              validatorText: "Please enter price",
                                              textEditingController: priceControllers[index],
                                              onChanged: (value) {
                                                if (value.isNotEmpty) {
                                                  variations[index].price = int.parse(value);
                                                }
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,color: Colors.red,),
                                            onPressed: () => removeVariation(setState,index),
                                          ),
                                        ],
                                      );
                                    }),


                                  ],
                                ),
                              )

                            );
                          },
                          listener: (BuildContext context, ProductState state) {
                            if (state is ProductAddSuccess) {
                              Navigator.pop(context);
                              ElegantNotification.success(
                                title:  const Text("Success",style: TextStyle(color: Colors.black),),
                                width: 300,
                                height: 100,
                                description:  Text(state.message,style: const TextStyle(color: Colors.black)),
                              ).show(context);
                            }
                            else if(state is ProductAddFailure){
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
                               if(imageBytes!=null){
                                 ProductItemDTO productItemDTO = ProductItemDTO(
                                   name: _name.text,
                                   imageByte: imageBytes!,
                                   type: variations.isNotEmpty? "package":"single",
                                   price: int.parse(_price.text),
                                   variations: packageSwitchValue ? variations : [],
                                   categoryId: _selectedCategory!.id,
                                   categoryName: _selectedCategory!.name,
                                 );

                                  context.read<ProductBloc>().add(AddProductEvent(productItemDTO));
                               }else{
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
                fixedSize: const Size(140, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              label: Text("Add New",style: GoogleFonts.inter(
                  color: Colors.white,fontSize: 14
              )),
              icon: const Icon(Icons.add,color: Colors.white,),
            ),
            const SizedBox(width: 20,),
            IconButton(onPressed: (){
              context.read<ProductBloc>().add(FetchProductEvent());
            }, icon: const Icon(Icons.refresh,size: 30,color: Colors.white,))

          ],
        ),
        const SizedBox(height: 20,),
        Expanded(
          child: BlocBuilder<ProductBloc,ProductState>(
              builder: (context,state) {

                if(state is ProductFetchSuccess){
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
                          DataColumn(label: Text("Product Name",style: Theme.of(context).textTheme.bodyMedium,)),
                          DataColumn(label: Text("Category Name",style: Theme.of(context).textTheme.bodyMedium,)),
                          DataColumn(label: Text("Type",style: Theme.of(context).textTheme.bodyMedium,)),
                        ],
                        rows: [
                          ...state.products.map((e) => DataRow(
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
                                DataCell(Text(e.categoryName,style: Theme.of(context).textTheme.bodyMedium,)),
                                DataCell(Text(e.type,style: Theme.of(context).textTheme.bodyMedium,)),

                              ]
                          )
                          )
                        ],

                      ),
                    ),


                  );
                }else if(state is ProductFetchLoading){
                  return const Center(child: CircularProgressIndicator(),);
                }
                else if(state is ProductFetchFailure){
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
