module Lims
  module LaboratoryApp
    # Test a way to increment version in a merged-friendly way
    # Each user need to add an x, in its appropriate section (this will
    # avoid collision)
    # and clear eventually the minor version of everybody .
    # Please leave the marker of other developper
    #
    MINOR_DEV = %{
    --llh1
    --ke4
    --mb14
    x
    x
    x
    }

    MAJOR_DEV = %{
    --llh1
    --ke4
    --mb14
    }


    VERSION = "3.0.6.#{MAJOR_DEV.scan(/\sx/i).size}.#{MINOR_DEV.scan(/\sx/i).size}"
  end
end
