import 'package:cool_store/models/product.dart';
import 'package:cool_store/screens/checkout_screen.dart';
import 'package:cool_store/screens/detail_screen.dart';
import 'package:cool_store/screens/wishlist_screen.dart';
import 'package:cool_store/states/app_state.dart';
import 'package:cool_store/states/cart_state.dart';
import 'package:cool_store/states/checkout_state.dart';
import 'package:cool_store/utils/constants.dart';
import 'package:cool_store/widgets/Badge.dart';
import 'package:cool_store/widgets/CartItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO change total
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartState state = Provider.of<CartState>(context);
    return SafeArea(
        child: CustomScrollView(
      slivers: <Widget>[
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Text(
                    'Cart',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        fontSize: 40),
                  ),
                ),
                Spacer(),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => WishListScreen(),
                          fullscreenDialog: true));
                    },
                    child: Badge(
                      iconData: Icons.shopping_cart,
                    ),
                  ),
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
          ),
          state.products.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Total items ${state.productsInCart.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Raleway',
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 17, vertical: 2),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.products.length,
                        itemBuilder: (context, pos) {
                          Product product =
                              state.products.values.elementAt(pos);
                          ProductVariation variation = state
                              .productVariationsInCart[product.id.toString()];
                          return CartItem(
                            product: product,
                            quantity:
                                state.productsInCart[product.id.toString()],
                            variation: variation,
                            onPrimaryButtonPressed: () {
                              state.addProductToWishList(product, variation);
                            },
                            onRemovePressed: () {
                              state.removeProduct(product.id);
                            },
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailScreen(product),
                                  fullscreenDialog: true));
                            },
                          );
                        }),
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // coupon view

                          Container(
                            height: Constants.screenAwareSize(35, context),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[600])),
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    onChanged: (value) {
//                                      state.setCouponCode(value);
                                    },
                                    onSubmitted: (value) {
                                      // TODO check for code
                                      state.setCouponCode(value);
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Coupon Code',
                                        hintStyle: TextStyle(
                                            fontFamily: 'Raleway',
                                            color: Theme.of(context)
                                                .textTheme
                                                .subhead
                                                .color),
                                        focusedBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none),
                                  ),
                                ),
                                Expanded(
                                  child: FlatButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.local_offer),
                                      label: Text('Apply')),
                                )
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: ListTile(
                              leading: Text('Total'),
                              trailing: Text('${state.totalCartAmount}'),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider<CheckoutState>(
                                              builder: (_) => CheckoutState(),
                                              child: Checkout(
                                                productsInCart:
                                                    state.productsInCart,
                                                productVariationsInCart: state
                                                    .productVariationsInCart,
                                              )),
                                      fullscreenDialog: true));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: Constants.screenAwareSize(40, context),
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor),
                              child: Center(
                                child: Text(
                                  'CHECKOUT',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Image.asset(
                        'empty_cart.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        'Looks like you haven\'t made your choice yet !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 40,
                            fontWeight: FontWeight.w200),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: FlatButton(
                            color: Theme.of(context).accentColor,
                            onPressed: () {

                            },
                            child: Text(
                              'CONTINUE SHOPPING',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Raleway'),
                            ))),
                    if (state.wishListProducts.length > 0)
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => WishListScreen(),
                                    fullscreenDialog: true));
                              },
                              child: Text(
                                'WISHLIST',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontFamily: 'Raleway'),
                              ))),
                  ],
                )
        ]))
      ],
    ));
  }
}
