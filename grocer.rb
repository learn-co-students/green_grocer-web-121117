require 'pry'

def consolidate_cart(cart)
  cart.each_with_object({}) do |item, result|
    item.each do |type, attributes|
      if result[type]
        attributes[:count] += 1
      else
        result[type] = attributes
        attributes[:count] = 1
      end
    end
  end
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart[coupon[:item]] && cart[coupon[:item]][:count] >= coupon[:num]
      if cart["#{coupon[:item]} W/COUPON"]
        cart["#{coupon[:item]} W/COUPON"][:count] += 1
      else
        #binding.pry
        cart["#{coupon[:item]} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{coupon[:item]} W/COUPON"][:clearance] = cart[coupon[:item]][:clearance]
      end
      cart[coupon[:item]][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |itemName, attributes|
    if attributes[:clearance]
      newPrice = attributes[:price] * 0.80
      attributes[:price] = newPrice.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  consolidatedCart = consolidate_cart(cart)
  cartWithCoupons = apply_coupons(consolidatedCart, coupons)
  newCart = apply_clearance(cartWithCoupons)
  newCart.each do |item, attributes|
    total += attributes[:price] * attributes[:count]
  end
    if total > 100
      total = total * 0.90
    end
  total
end
