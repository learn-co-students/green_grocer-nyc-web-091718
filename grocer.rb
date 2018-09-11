require 'pry'
def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |food_item|
    food_item.each do |key, value|
      if consolidated_cart.include?(key)
        consolidated_cart[key][:count] += 1
      else
        value[:count] = 1
        consolidated_cart[key] = value
      end
    end
  end
  consolidated_cart
end



def apply_coupons(cart, coupons)
    new_cart = {}
    cart.each do |key, value|
      new_cart[key] = {:price=>value[:price], :clearance=>value[:clearance], :count=>value[:count]}
      c_properties = coupons.find { |coupon| coupon[:item] == key }
      if c_properties
        new_cart["#{key} W/COUPON"] = {:price=>c_properties[:cost], :clearance=>value[:clearance], :count=> value[:count] / c_properties[:num]}
        new_cart[key][:count] = value[:count] % c_properties[:num]
      end
    end
    new_cart
end

def apply_clearance(cart)
  new_cart = {}
  cart.each do |key, value|
    price = value[:price]
    if value[:clearance]
      price = price - price * 0.2
    end

    new_cart[key] = {:price=>price, :clearance=>value[:clearance], :count=>value[:count]}
  end
  new_cart
end

def checkout(cart, coupons)
  completed_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total = 0
  completed_cart.each do |key, value|
      total += value[:price] * value[:count]
  end
  if total > 100
    total = total - total * 0.1
  end
  total
end
