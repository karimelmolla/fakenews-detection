import 'package:first_project/models/slider_model.dart';
import 'package:first_project/models/category_model.dart';
import 'package:first_project/pages/home.dart';

List<sliderModel> getSliders() {
  List<sliderModel> slider = [];
  sliderModel categoryModel = new sliderModel();

  categoryModel.image = "images/pic.jpg";
  categoryModel.name = "All";
  slider.add(categoryModel);
  categoryModel = new sliderModel();

  categoryModel.image = "images/pic.jpg";
  categoryModel.name = "All";
  slider.add(categoryModel);
  categoryModel = new sliderModel();

  categoryModel.image = "images/pic.jpg";
  categoryModel.name = "All";
  slider.add(categoryModel);
  categoryModel = new sliderModel();

  categoryModel.image = "images/pic.jpg";
  categoryModel.name = "All";
  slider.add(categoryModel);
  categoryModel = new sliderModel();

  return slider;
}
