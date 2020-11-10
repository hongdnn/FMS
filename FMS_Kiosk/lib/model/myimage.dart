class MyImage{
  String imageId;
  String imageName;
  String brandId;
  String imageLink;
  String username;
  String createDate;
  String brand;

  MyImage({
    this.imageId,
    this.imageName,
    this.brandId,
    this.imageLink,
    this.username,
    this.createDate,
    this.brand
  });

  factory MyImage.fromJson(Map<String, dynamic> json) {
    return MyImage(
      imageId: json['ImageId'],
      imageName: json['ImageName'],
      brandId: json['BrandId'],
      imageLink: json['ImageLink'],
      username: json['Username'],
      createDate: json['CreateDate'],
      brand: json['Brand'],
    );
  }

}