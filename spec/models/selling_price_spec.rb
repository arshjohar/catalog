require 'spec_helper'

describe SellingPrice do

  it { should have_fields(:seller_name, :base_price, :total_price).of_type(String) }

end
