require 'pry'

def consolidate_cart(cart)
  output_hash = {}
  cart.each do |product|
    product.each do |name, values|
      if output_hash.include? name
        values[:count] += 1
        output_hash[name] = values
      else
        values[:count] = 1
        output_hash[name] = values
      end
    end
  end
  output_hash
end

def apply_coupons(cart, coupons)
  output_hash = {}
  cart.each do |name, values|
    coupons.each do |coupon|
      if name == coupon[:item] && values[:count] >= coupon[:num]
        cart[name][:count] -= coupon[:num]
        if output_hash["#{name} W/COUPON"]
          output_hash["#{name} W/COUPON"][:count] += 1
        else
          output_hash["#{name} W/COUPON"] = {:price => coupon[:cost], :clearance => values[:clearance], :count => 1}
        end
      end
    end
    output_hash[name] = values
    # binding.pry
  end
  output_hash
  # cart.each do |name, values|
  #   output_hash[name] = values
  #   coupon_count = 0
  #
  #   coupon_array = coupons.collect do |coupon|
  #     if coupon[:item] == name
  #       coupon_count += 1
  #     end
  #   end
  #
  #   coupon = coupons.find do |coupon|
  #     coupon[:item] == name
  #   end
  #   # if coupon_count > 1
  #   #   # binding.pry
  #   # end
  #   if coupon && values[:count] >= coupon[:num]
  #     output_hash["#{name} W/COUPON"] = {:price => coupon[:cost], :clearance => values[:clearance], :count => coupon_count}
  #     output_hash[name][:count] = output_hash[name][:count] - coupon[:num]*coupon_count
  #   end
  #
  # end
  # output_hash
end

def apply_clearance(cart)
  output_hash = {}
  cart.each do |name, values|
    if cart[name][:clearance]
      discounted_price = values[:price] * 0.8
      values[:price] = discounted_price.round(2)
    end
  end
end

def checkout(cart, coupons)

  complete_cart = apply_clearance(apply_coupons(consolidate_cart(cart),coupons))
  total_price = 0
  coupons.each do |coupon|
    if coupon
      # binding.pry
    end
  end

  complete_cart.each do |name, value|
    total_price += (value[:count] * value[:price])
  end

  if total_price > 100
    total_price *= 0.9
  else
    total_price
  end

end
