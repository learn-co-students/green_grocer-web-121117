#require "pry"
def consolidate_cart(cart)
  result = {}
  cart.each do |item|
    item.each do |name, details|
      if !result.has_key?(name)
        result[name] = details
        result[name][:count] = 1
      else
        result[name][:count] += 1
      end
    end
  end
  result
end

def apply_coupons(cart, coupons)
  discounted = {}
  if coupons.length == 0
    return cart
  end
  
  cart.each do |item, details|
    coupons.each do |coupon|
      
      if item == coupon[:item] && !discounted.include?("#{item} W/COUPON")
        if coupon[:num] == details[:count]
          discounted[item] = details
          discounted[item][:count] = 0
          discounted["#{item} W/COUPON"] = {price: coupon[:cost], clearance: details[:clearance], count: 1}
        elsif coupon[:num] < details[:count]
          discounted[item] = details
          discounted[item][:count] = details[:count] - coupon[:num]
          discounted["#{item} W/COUPON"] = {price: coupon[:cost], clearance: details[:clearance], count: 1}
        else
          indiv_price = coupon[:cost] / coupon[:num]
          discounted["#{item} W/COUPON"] = {price: indiv_price * details[:count], clearance: details[:clearance], count: 1}
        end
      elsif item == coupon[:item] && discounted.include?("#{item} W/COUPON")
        if discounted[item][:count] >= coupon[:num]
          discounted[item][:count] -= coupon[:num]
          discounted["#{item} W/COUPON"][:count] += 1
        end
      else
        discounted[item] = details
      end
    end
  end
  
  discounted
end

def apply_clearance(cart)
  cart.each do |item, details|
    if details[:clearance] == true
      details[:price] -= details[:price] * 0.2
    end
  end
  cart
end

def checkout(cart, coupons)
  con_cart = consolidate_cart(cart)
  disc_cart = apply_coupons(con_cart, coupons)
  clear_cart = apply_clearance(disc_cart)
  total = 0
  clear_cart.each do |item, details|
    total += details[:price] * details[:count]
  end
  if total >= 100
    total -= total * 0.1
  end
  total
end
