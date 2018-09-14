require "pry"

def consolidate_cart(cart)
  consolidated_hash = {}

  cart.each do |item_hash|
    item_hash.each do |name, descriptor|
        if consolidated_hash.include?(name)
          consolidated_hash[name][:count] += 1
        else
          descriptor[:count] = 1
          consolidated_hash[name] = descriptor
        end
      end
    end
  consolidated_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |c|
    food = c[:item]
      if cart[food] && (cart[food][:count] >= c[:num])
        if cart["#{food} W/COUPON"]
          cart["#{food} W/COUPON"][:count] += 1
        else
          cart["#{food} W/COUPON"] = {
            :price => c[:cost], :count => 1
          }
          cart["#{food} W/COUPON"][:clearance] = cart[food][:clearance]
        end
        cart[food][:count] -= c[:num]
      end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, item_hash|
    if item_hash[:clearance] == true
        new_price = item_hash[:price] * 0.8
        item_hash[:price] = new_price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  final_total = 0
  complete_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(complete_cart, coupons)
  final_cart = apply_clearance(coupon_cart)

  final_cart.each do |k, v|
    final_total += (v[:count] * v[:price])
  end
  if final_total > 100
    final_total *= 0.9
  else
    final_total
  end
end
