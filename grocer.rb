require 'pry'

def consolidate_cart(cart)
newcart  = {}
  cart.each do |item|
    item.each do |name, values|
      values.each do |attribute, value|
        if !newcart.include?(name)
          newcart[name] = {}
        end
        newcart[name][attribute] = value
      end
      if !newcart[name][:count]
        newcart[name][:count] = 0
      end
      newcart[name][:count] += 1
    end
  end
  newcart
end

def apply_coupons(cart, coupons)
  newcart = {}
  cart.each do |name, stats| #iterating through initial key value pairs
    newcart[name] = stats #adding each original pair to new cart
    coupons.each do |coupon| #going through each coupon per pair
      if (coupon[:item] == name) && (stats[:count] >= coupon[:num]) #matching coupon to keys
        newname = name + " W/COUPON" #for readability
        newcart[newname] = {} #if there's a match, adds key value pair for couponed item
        newcart[newname][:price] = coupon[:cost] #setting couponed price to coupon price
        newcart[newname][:clearance] = stats[:clearance] #maintaining clerance value
        newcart[newname][:count] = (stats[:count]/coupon[:num]) #setting couponed count to number of times coupon applied
        newcart[name][:count] = (stats[:count]%coupon[:num]) #setting original count to remainder
      end
    end
  end
  newcart
end

def apply_clearance(cart)
  cart.each do |item, stats|
    if cart[item][:clearance] == true
      cart[item][:price] = (cart[item][:price] * 0.8).round(1)
    end
  end
end

def checkout(cart, coupons)
  newcart = consolidate_cart(cart)
  newcart = apply_coupons(newcart, coupons)
  newcart = apply_clearance(newcart)
  total = 0.00
  newcart.each do |item, stats|
    total += stats[:price]*stats[:count]
  end
  #binding.pry
  if total > 100
    total *= 0.9
  end
  total
end
