def consolidate_cart(cart)
  cart_hash = {}
   cart.each do |item|
     item.each do |name, attribute|
       if cart_hash.has_key?(name)
         cart_hash[name][:count] += 1
       else
         cart_hash = cart_hash.merge({name => attribute.merge({count: 1})})
       end
     end
   end
   return cart_hash
 end

def apply_coupons(cart, coupons)
  cart_hash = cart

  coupons.each do |coupon|
    item_name = coupon[:item]
    if cart_hash.keys.include?(item_name)
      cart_count = cart_hash[item_name][:count]

      if cart_count >= coupon[:num]
        item_coup = {"#{item_name} W/COUPON" => {
          price: coupon[:cost],
          clearance: cart_hash[item_name][:clearance],
          count: cart_count/coupon[:num]}
        }

        cart_hash[item_name][:count] %= coupon[:num]
        cart_hash = cart_hash.merge(item_coup)
      end
    end
  end
  return cart_hash
end

def apply_clearance(cart)
  cart.each do |item, attribute|
    if attribute[:clearance] == true
      attribute[:price] = (attribute[:price]*0.8).round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)
total = 0
cart = consolidate_cart(cart)

if cart.length == 1
  cart = apply_coupons(cart, coupons)
  cart_clearance = apply_clearance(cart)
  if cart_clearance.length > 1
    cart_clearance.each do |item, details|
      if details[:count] >=1
        total += (details[:price]*details[:count])
      end
    end
  else
    cart_clearance.each do |item, details|
      total += (details[:price]*details[:count])
    end
  end
else
  cart = apply_coupons(cart, coupons)
  cart_clearance = apply_clearance(cart)
  cart_clearance.each do |item, details|
    total += (details[:price]*details[:count])
  end
end

if total > 100
  total = total*(0.90)
end

  total
end
