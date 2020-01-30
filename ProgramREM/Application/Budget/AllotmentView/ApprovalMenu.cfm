        <cfif Method neq "">
 		   <tr bgcolor="CCFFCC">
		<cfelse>
    	   <tr>
		</cfif>
<!---	
		
		<cfset CLIENT.Verbose eq "0">
		
		<cfif #MenuClass# eq "Component">
			<td></td>
			<td width="3%" valign="top" class="#ComClass#">&nbsp;&nbsp;
			<img src="#SESSION.root#/Images/join.gif" alt="" width="19" height="16" border="0" align="bottom"></A>&nbsp;			
		<cfelse>
			<td width="5%" align="right" class="regular">		
		</cfif>
		
		<cfif #Method# neq "">
	
		<img src="#SESSION.root#/Images/check.gif" alt="" name="img0_#CLIENT.dropdownno#" 
			  onMouseOver="document.img0_#CLIENT.dropdownno#.src='#SESSION.root#/Images/button.jpg'" 
			  onMouseOut="document.img0_#CLIENT.dropdownno#.src='#SESSION.root#/Images/check.gif'"
			  style="cursor: pointer;" alt="" width="10" height="10" border="0" align="middle" 
			  onClick="expand('menu','#CLIENT.dropdownno#')">&nbsp;
			  
			  <CFIF #BudgetAccess# EQ "ALL"> 

			   <cf_dropDownMenu
			     name="menu"
		   	     headerName="Approval"
			     menuRows="2"
				 							 
		         menuName1="Approve"
			     menuAction1="AllotmentInquiry('#MenuProgramCode#','#URL.Fund#','#URL.Period#','#Method#')"
			     menuIcon1="#SESSION.root#/Images/excel.jpg"
			     menuStatus1="Program allotment"	  
			  
			     menuName2="Attachment"
			     menuAction2="javascript:addfile('#Parameter.DocumentLibrary#','#MenuProgramCode#','')"
			     menuIcon2="#SESSION.root#/Images/copy.jpg"
			     menuStatus2="Attach a document">	  
				 
				 <cf_filelibraryN
             		DocumentPath="#Parameter.DocumentLibrary#"
               		SubDirectory="#MenuProgramCode#" 
              		Filter=""
                	Insert="no"
             		Remove="no"
            		Highlight="no"
              		Listing="no">
					
			  	<cfelse>
					  
				  <cf_dropDownMenu
				     name="menu"
			    	 headerName="#MenuClass#"
				     menuRows="1"
				     
					 menuName1="View program"
				     menuAction1="javascript:ViewProgram('#MenuProgramCode#','#Period#','#MenuClass#')"
				     menuIcon1="#SESSION.root#/Images/document.gif"
				     menuStatus1="View program">
					 
				</cfif>

		<cfelse>
								
		 <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#CLIENT.dropdownno#" 
			  onMouseOver="document.img0_#CLIENT.dropdownno#.src='#SESSION.root#/Images/button.jpg'" 
			  onMouseOut="document.img0_#CLIENT.dropdownno#.src='#SESSION.root#/Images/view.jpg'"
			  style="cursor: pointer;" alt="" width="12" height="14" border="0" align="middle" 
			  onClick="expand('menu','#CLIENT.dropdownno#')">&nbsp;
			  					  	  
			  <CFIF ListFind("ALL,EDIT",#BudgetAccess#) GT 0> 
					 	 
		      <cf_dropDownMenu
			     name="menu"
		   	     headerName="#MenuClass#"
			     menuRows="3"
				 
				 menuName1="View program"
			     menuAction1="javascript:ViewProgram('#MenuProgramCode#','#Period#','#MenuClass#')"
			     menuIcon1="#SESSION.root#/Images/document.gif"
			     menuStatus1="View program"
				 
		         menuName2="Allotment"
			     menuAction2="javascript:Allotment('#MenuProgramCode#','#URL.Fund#','#URL.Period#','')"
			     menuIcon2="#SESSION.root#/Images/excel.jpg"
			     menuStatus2="Program allotment"	  
			  
			     menuName3="Attachment"
			     menuAction3="javascript:addfile('#Parameter.DocumentLibrary#','#MenuProgramCode#','')"
			     menuIcon3="#SESSION.root#/Images/copy.jpg"
			     menuStatus3="Attach a document">	  
				 
				  <cf_filelibraryN
             		DocumentPath="#Parameter.DocumentLibrary#"
               		SubDirectory="#MenuProgramCode#" 
              		Filter=""
                	Insert="no"
             		Remove="no"
            		Highlight="no"
              		Listing="no">
		  	
			  <cfelse>
			  
				  <cf_dropDownMenu
				     name="menu"
			    	 headerName="#MenuClass#"
				     menuRows="1"
				     
					 menuName1="View program"
				     menuAction1="javascript:ViewProgram('#MenuProgramCode#','#Period#','#MenuClass#')"
				     menuIcon1="#SESSION.root#/Images/document.gif"
				     menuStatus1="View program">
						 
			  </cfif>	
		</cfif>			
		
		<cfif #MenuClass# eq "Component">
			<cfif #Components.Status# eq "1">
				<img src="../../../../images/check.gif" alt="" width="10" height="10" border="0" align="middle">&nbsp;
			</cfif>
		 </cfif>
			
		</td>
						
--->  
