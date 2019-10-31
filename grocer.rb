def consolidate_cart(cart)
  consolidated = {}

  cart.each do |item|
    item.collect do |food, info|
      if !consolidated.has_key?(food)
        consolidated[food] = info
        consolidated[food][:count] = 1
      else
        consolidated[food][:count] += 1
      end
    end
  end
  consolidated
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    food = coupon[:item]
    if cart[food] && cart[food][:count] >= coupon[:num]
      if cart["#{food} W/COUPON"]
        cart["#{food} W/COUPON"][:count] += 1
      else
        cart["#{food} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{food} W/COUPON"][:clearance] = cart[food][:clearance]
      end
      cart[food][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    if info[:clearance] == true
      info[:price] -= info[:price] * 0.2
    end
  end
  cart
end

def checkout(cart, coupons)
  cons = consolidate_cart(cart)
  coup = apply_coupons(cons, coupons)
  clear = apply_clearance(coup)
  total = 0

  clear.each do |item, info|
    total += info[:price] * info[:count]
  end
  if total >= 100
    total -= total * 0.1
  end
  total
end
