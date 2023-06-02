class ProductBasket {
  String? id_produit;
  String? image;
  String? nom;
  int? quantite_louer;
  int? prix;
  int? total;
  int? quantite_initial;

  ProductBasket(
      {this.id_produit,
      this.image,
      this.nom,
      this.quantite_louer,
      this.quantite_initial,
      this.prix,
      this.total});
}
