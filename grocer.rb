
def consolidate_cart(cart)
  current_cart = {}
  cart.each do |item|
    item.each do |name, details|
      if !current_cart.has_key?(name)
        current_cart[name] = details
        current_cart[name][:count] = 1
      else
        current_cart[name][:count] += 1
      end
    end
  end
  current_cart
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
  cart.each do |item, details|
    if details[:clearance] == true
      details[:price] -= details[:price] * 0.2
    end
  end
  cart
end

def checkout(cart, coupons)
  consol_cart = consolidate_cart(cart)
  discount_cart = apply_coupons(consol_cart, coupons)
  clearance_cart = apply_clearance(discount_cart)
  total = 0
  clearance_cart.each do |item, details|
    total += details[:price] * details[:count]
  end
  if total >= 100
    total -= total * 0.1
  end
  total
end
