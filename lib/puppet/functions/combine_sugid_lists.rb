#
#
Puppet::Functions.create_function(:combine_sugid_lists) do
  dispatch :list do
    param 'Array', :base
    param 'Array', :remove
    param 'Array', :add
  end

  def list(base, remove, add)
    (base - remove + add).uniq
  end
end
