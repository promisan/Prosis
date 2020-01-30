
<cf_dialogPosition>

<cfoutput>
	
	<script>
		
		function createAccount() {
		   
		   acc       = document.getElementById("account");
		   validate  = document.getElementById("result");
		   lastname  = document.getElementById("lastName");
		   firstname = document.getElementById("firstName");
		   
		   if (acc.value.length == 0) {
				alert('Please enter an account');
				return false;
		   }

			if (validate.value == 0){
				alert('Please enter a valid account');
				return false;
			}
			
			if (lastname.value.length == 0){
				alert('Please enter LastName');
				return false;
			}
			
			if (firstname.value.length == 0){
				alert('Please enter first name');
				return false;
			}
		
		  // document.newAccount.onsubmit() 
			//if( _CF_error_messages.length == 0 ) {
		       	ColdFusion.navigate('#SESSION.root#/System/AccessRequest/Workflow/NewAccountSubmit.cfm?acc='+acc.value+'&requestid=#object.ObjectKeyValue4#','div_submit','','','POST','newAccount')
			 //}  
			 
		 } 
	  
	</script>

</cfoutput>