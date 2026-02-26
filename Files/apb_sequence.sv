class apb_sequence extends uvm_sequence #(cmn_seq_item);
  `uvm_object_utils(apb_sequence)
  
  function new(string name="apb_sequence");
    super.new(name);
  endfunction
  
  //create,randomize & send item to driver
   virtual task body();
    req=cmn_seq_item::type_id::create("req");
     begin
        `uvm_info("first_sequence",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
        start_item(req);
        req.randomize();
        finish_item(req);
      end 
  endtask
  
endclass