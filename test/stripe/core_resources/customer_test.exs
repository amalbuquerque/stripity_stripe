defmodule Stripe.CustomerTest do
  use Stripe.StripeCase, async: true

  test "is creatable" do
    assert {:ok, %Stripe.Customer{}} = Stripe.Customer.create(%{})
    assert_stripe_requested(:post, "/v1/customers")
  end

  test "is retrievable" do
    assert {:ok, %Stripe.Customer{}} = Stripe.Customer.retrieve("cus_123")
    assert_stripe_requested(:get, "/v1/customers/cus_123")
  end

  test "is updateable" do
    params = %{metadata: %{key: "value"}}
    assert {:ok, %Stripe.Customer{}} = Stripe.Customer.update("cus_123", params)
    assert_stripe_requested(:post, "/v1/customers/cus_123")
  end

  test "is deletable" do
    {:ok, customer} = Stripe.Customer.retrieve("cus_123")
    assert_stripe_requested(:get, "/v1/customers/#{customer.id}")

    assert {:ok, %Stripe.Customer{}} = Stripe.Customer.delete(customer)
    assert_stripe_requested(:delete, "/v1/customers/#{customer.id}")
  end

  test "is listable" do
    assert {:ok, %Stripe.List{data: customers}} = Stripe.Customer.list()
    assert_stripe_requested(:get, "/v1/customers")
    assert is_list(customers)
    assert %Stripe.Customer{} = hd(customers)
  end

  describe "delete_discount/2" do
    test "deletes a customer's discount" do
      {:ok, customer} = Stripe.Customer.retrieve("sub_123")
      assert_stripe_requested(:get, "/v1/customers/#{customer.id}")

      assert {:ok, _} = Stripe.Customer.delete_discount("sub_123")
      assert_stripe_requested(:delete, "/v1/customers/#{customer.id}/discount")
    end
  end

  describe "update_cash_balance/3" do
    test "changes settings to customer cash balance" do
      params = %{settings: %{reconciliation_mode: "manual"}}
      assert {:ok, _} = Stripe.Customer.update_cash_balance("cus_123", params)
      assert_stripe_requested(:post, "/v1/customers/cus_123/cash_balance")
    end
  end
end
