require "pry"

def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each{ |item|
    item.each{ |key, value|
      consolidated_cart[key] = value
      !consolidated_cart[key][:count] ? consolidated_cart[key][:count] = 1 : consolidated_cart[key][:count] +=1
    }
  }
  consolidated_cart
end

def apply_coupons(cart, coupons)
  coupons_to_apply = []
  cart.each { |cart_item, attributes|
    coupons.each { |coupon|
      if coupon[:item] == cart_item && attributes[:count] >= coupon[:num]
        coupon_name = "#{cart_item} W/COUPON"
        if !coupons_to_apply.include?(coupon_name)

          coupon_count = attributes[:count] / coupon[:num]
          coupon_hash = {}
          coupon_hash[coupon_name] = {}

          attributes[:count] -= coupon[:num]
          coupon_hash[coupon_name].replace(attributes)
          coupon_hash[coupon_name][:count] = coupon_count
          coupon_hash[coupon_name][:price] = coupon[:cost]
          coupons_to_apply.push(coupon_hash)
        else
          coupons_to_apply[coupons_to_apply.index(coupon)].values[0][:count] += 1
        end
      end
    }
  }

  coupons_to_apply.each { |coupon|
    if cart.include?(coupon.keys[0]) && cart[coupon.keys[0]][:count] > coupon.values[0][:count]
      cart
    else
      cart.update(coupon)
    end
  }

  cart
end

def apply_clearance(cart)
  cart.each do |cart_item, attributes|
    if attributes[:clearance]
      attributes[:price] *= 0.8
      attributes[:price] = attributes[:price].round(1)
    end
  end
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  total = 0
  final_cart.each do |cart_item, attributes|
    total += (attributes[:price] * attributes[:count])
  end
  if total >= 100
    total *= 0.9
    total = total.round(1)
  end
  total
end
