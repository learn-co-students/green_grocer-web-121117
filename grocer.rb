require "pry"

def consolidate_cart(cart)
  new_cart = Hash.new(0)
  cart.each do |key,value|
    key.each do |item,info|
      new_cart[item] = info
      if new_cart[item][:count].nil?
        new_cart[item][:count] = 1
      else
        new_cart[item][:count] += 1
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  hold = Hash.new(0)
  cart.each do |key,value|
    coupons.each do |x|
      if x[:item] == key && value[:count] >= x[:num]
        hold["#{key} W/COUPON"] = {price: x[:cost], clearance: value[:clearance],count: 0}
        while value[:count] >= x[:num]
          hold["#{key} W/COUPON"][:count] += 1
          value[:count] -= x[:num]
        end
      end
    end
  end
  cart.merge!(hold)
  cart
end

def apply_clearance(cart)
  cart.each do |key,value|
    if value[:clearance] == true
      value[:price] = value[:price] - (value[:price] * 0.2)
    end
  end
end

def checkout(cart, coupons)
  hold = consolidate_cart(cart)
  hold = apply_coupons(hold,coupons)
  hold = apply_clearance (hold)
  total = 0
  hold.each do |key,value|
    total += value[:price] * value[:count]
  end
  if total >= 100
    total = total - (total * 0.1)
  end
  total
end
