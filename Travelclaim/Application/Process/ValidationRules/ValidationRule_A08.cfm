<cfsilent>
<proUsr>Joseph George</proUsr>
  <proOwn>Joseph George</proOwn>
 <proDes>Template for validation Rule A08  </proDes>
 <proCom>New File For Validation A08 </proCom>
</cfsilent>

<!--- 
						Validation Rule :  A08
						Name			:  Incorporated in A04 
						                   The logic is simple Check for REquireRequestLine = True or 1
										   Based against the Check of all the claims ,and then loop it 
										   with individual claimcategory and find whether the 
										   claimcategory in question are Ref_claimcategory.
											
											
						Steps			:  Check Claim categorys and loop it within Ref_claimCategory table 
						                   and find out whether RequireRequestLine is set to be true or not.
										   
						Date			:  18 Sep 2007
						Last date		:  18 Sep 2007
--->

