class CreateSignatures < ActiveRecord::Migration
  def up
    create_table :signatures do |t|
      t.string :name_ua
      t.string :name_en
      t.string :title_en
      t.string :title_ua
      t.string :tel
      t.string :email

      t.timestamps
    end

    add_reference :client_acts, :signature, index: true
    add_reference :client_invoices, :signature, index: true
    add_reference :vendor_acts, :signature, index: true
    add_reference :vendor_orders, :signature, index: true

    signature = Signature.create(signature_attributes)

    ClientInvoice.all.update_all(signature_id: signature.id)
    ClientAct.all.update_all(signature_id: signature.id)
    VendorOrder.all.update_all(signature_id: signature.id)
    VendorAct.all.update_all(signature_id: signature.id)
  end

  def down
    drop_table :signatures

    remove_reference :client_acts, :signature
    remove_reference :client_invoices, :signature
    remove_reference :vendor_acts, :signature
    remove_reference :vendor_orders, :signature
  end

  def signature_attributes
    { name_ua: 'Корпань Євгеній Олександрович',
      name_en: 'Ievgenii O. Korpan',
      title_ua: 'Генеральний директор',
      title_en: 'CEO',
      tel: '+38097753573',
      email: 'eugene@active-bridge.com' }
  end
end
