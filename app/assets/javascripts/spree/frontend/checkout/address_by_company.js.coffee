#refer to frontend/checkout/address.js.coffee
Spree.ready ($) ->
  Spree.onAddress = () ->
    if ($ '#checkout_form_address').length
      order_use_company_address = ($ 'input#order_use_company_address')
      order_use_company_address.change ->
        update_billing_form_state order_use_company_address

      update_billing_form_state = (order_use_company_address) ->
        if order_use_company_address.is(':checked')
          ($ '#billing .inner').hide()
          ($ '#billing .inner input, #billing .inner select').prop 'disabled', false
          #get data company address, and replace input form
          $.ajax '/account/company_address',
            type: 'GET'
            contentType: "application/json"
            dataType: "json"
            error: (error) ->
                console.log(error)
            success: (data) ->
                company_address = data
                ($ 'input#order_bill_address_attributes_firstname').val(company_address.firstname)
                ($ 'input#order_bill_address_attributes_lastname').val(company_address.lastname)
                ($ 'input#order_bill_address_attributes_address1').val(company_address.address1)
                ($ 'input#order_bill_address_attributes_address2').val(company_address.address2)
                ($ 'input#order_bill_address_attributes_city').val(company_address.city)
                ($ '#order_bill_address_attributes_country_id').val(company_address.country_id).attr("selected", "true");
                ($ '#order_bill_address_attributes_state_id').val(company_address.state_id).attr("selected", "true");
                ($ 'input#order_bill_address_attributes_zipcode').val(company_address.zipcode)
                ($ 'input#order_bill_address_attributes_phone').val(company_address.phone)
        else
          ($ '#billing .inner').show()
          ($ '#billing .inner input, #billing .inner select').prop 'disabled', false
          Spree.updateState('b')

      update_billing_form_state order_use_company_address
  Spree.onAddress()