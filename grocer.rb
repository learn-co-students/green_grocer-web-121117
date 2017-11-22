def consolidate_cart(cart)
  hash = {}
  cart.each do |items|
    items.each do |name, stats|
      if hash[name]
        hash[name][:count] += 1
      else
        hash[name] ||= stats
        hash[name][:count] = 1
      end
    end
  end
  hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
end


def apply_clearance(cart)
  cart.each { |item, stats| stats[:price] = (cart[item][:price] * 0.8).round(1) if stats[:clearance] == true}
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  clearance_cart = apply_clearance(couponed_cart)

  total = 0
  clearance_cart.each { |name, stats| total += stats[:price] * stats[:count]}
  total *= 0.9 if total >= 100
  total
end
