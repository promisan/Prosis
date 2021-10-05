

<CFParam name="Attributes.class"        default="employee">		
<CFParam name="Attributes.datasource"   default="">		
<CFParam name="Attributes.title"        default="Search">	
<CFParam name="Attributes.box"          default="">   <!--- destination box --->
<CFParam name="Attributes.id"           default="lookuplink">		
<CFParam name="Attributes.module"       default=""> 
<CFParam name="Attributes.formname"     default=""> 
<CFParam name="Attributes.pfunction"     default=""> 
<CFParam name="Attributes.link"         default="">
<CFParam name="Attributes.form"         default="">
<CFParam name="Attributes.modal"        default="true">
<CFParam name="Attributes.close"        default="No">
<CFParam name="Attributes.button"       default="No">
<CFParam name="Attributes.icon"         default="locate.gif">
<CFParam name="Attributes.iconheight"   default="15">
<CFParam name="Attributes.iconwidth"    default="15">
<CFParam name="Attributes.style"        default="">
<CFParam name="Attributes.dbtable"      default="">
<CFParam name="Attributes.des1"         default="">
<CFParam name="Attributes.des2"         default="">
<CFParam name="Attributes.filter1"      default="">
<CFParam name="Attributes.filter1value" default="">
<CFParam name="Attributes.filter2"      default="">
<CFParam name="Attributes.filter2value" default="">
<CFParam name="Attributes.filter3"      default="">
<CFParam name="Attributes.filter3value" default="">
<CFParam name="Attributes.filter4"      default="">
<CFParam name="Attributes.filter4value" default="">

<!--- ----------------------- --->
<!--- start <cf_button params --->
<!--- ----------------------- --->

<cfset init = structNew()>
<cfparam name="Attributes.buttonlayout" type="struct" default="#init#">

<CFParam name= "Attributes.buttonlayout.label2"       default="">
<CFParam name= "Attributes.buttonlayout.icon"         default="">
<CFParam name= "Attributes.buttonlayout.color"        default="0b0b0b">
<cfparam name= "Attributes.buttonlayout.height"       default="25">
<cfparam name= "Attributes.buttonlayout.imageheight"  default="32">
<cfparam name= "Attributes.buttonlayout.imagepos"     default="left">
<cfparam name= "Attributes.buttonlayout.type"         default="">
<cfparam name= "Attributes.buttonlayout.font"         default="verdana">
<cfparam name= "Attributes.buttonlayout.transform"    default="none">
<cfparam name= "Attributes.buttonlayout.alt"          default="">
<cfparam name= "Attributes.buttonlayout.onmouseover"  default="yes">
<cfparam name= "Attributes.buttonlayout.onmouseout"   default="yes">
<cfparam name= "Attributes.buttonlayout.onmousedown"  default="yes">

<cfif Attributes.buttonlayout.label2 neq "">
	<CFParam name= "Attributes.buttonlayout.mode"        default="silverlarge">
	<CFParam name="Attributes.buttonlayout.width"        default="120">
	<cfparam name="Attributes.buttonlayout.paddingtop"   default="3px">
	<cfparam name="Attributes.buttonlayout.align"        default="left">
	<cfparam name="Attributes.buttonlayout.paddingleft"  default="5px">
	<cfparam name="Attributes.buttonlayout.fontsize"     default="18">
	<cfparam name="Attributes.buttonlayout.fontweight"   default="bold">
	<cfparam name="Attributes.buttonlayout.iconheight"   default="29px">
	<cfparam name="Attributes.buttonlayout.lineheight"   default="17px">
	
<cfelse>

	<CFParam name= "Attributes.buttonlayout.mode"        default="grayshadow">
	<CFParam name="Attributes.buttonlayout.width"        default="">
	<cfparam name="Attributes.buttonlayout.paddingtop"   default="0px">
	<cfparam name="Attributes.buttonlayout.align"        default="center">
	<cfparam name="Attributes.buttonlayout.paddingleft"  default="3px">
	<cfparam name="Attributes.buttonlayout.fontsize"     default="12">
	<cfparam name="Attributes.buttonlayout.fontweight"   default="normal">
	<cfparam name="Attributes.buttonlayout.iconheight"   default="19px">
	<cfparam name="Attributes.buttonlayout.lineheight"   default="">
	
</cfif>	
	
<!--- ----------------------- --->
<!---  end  <cf_button params --->
<!--- ----------------------- --->
			
<cfset class      = attributes.class>
<cfset datasource = attributes.datasource>
<cfset pfunction   = attributes.pfunction>
<cfset box        = attributes.box>
<cfset icon       = attributes.icon>
<cfset link       = attributes.link>
<cfset dbtable    = attributes.dbtable>
<cfset des1       = attributes.des1>
<cfset des2       = attributes.des2>

<!--- ------------------------------------------ --->
<!--- retrieve value on the fly for the filter 1 --->
<!--- ------------------------------------------ --->

<cfset fil1     = attributes.filter1>
<cfset fval1    = attributes.filter1value>

<cfset start = "1">
<cfset new   = attributes.filter1value>

<cfloop condition="#start# lte #len(new)#">
		
		<cfif find("{","#new#",start)>
				
			<cfset str    = find("{","#new#",start)>
			<cfset str   = str+1>
			<cfset end   = find("}","#new#",start)>
			<cfset end   = end>
			
			<cfset fld   = Mid(new, str, end-str)>
			<cfset fval1 = "'+document.getElementById('#fld#').value+'">			
						
			<cfset start = end>
			
		<cfelse>
		
			<cfset start = len(new)+1>	

		</cfif> 
	
</cfloop>		

<!--- ------------------------------------------ --->
<!--- retrieve value on the fly for the filter 2 --->
<!--- ------------------------------------------ --->

<cfset fil2   = attributes.filter2>
<cfset fval2  = attributes.filter2value>

<cfset start = "1">
<cfset new   = attributes.filter2value>
<cfloop condition="#start# lte #len(new)#">
		
		<cfif find("{","#new#",start)>
				
			<cfset str = find("{","#new#",start)>
			<cfset str = str+1>
			<cfset end = find("}","#new#",start)>
			<cfset end = end>
			
			<cfset fld = Mid(new, str, end-str)>
			<cfset fval2 = "'+document.getElementById('#fld#').value+'">			
						
			<cfset start = end>
			
		<cfelse>
		
			<cfset start = len(new)+1>	

		</cfif> 
	
</cfloop>	

<!--- ------------------------------------------ --->

<!--- ------------------------------------------ --->
<!--- retrieve value on the fly for the filter 3 --->
<!--- ------------------------------------------ --->

<cfset fil3   = attributes.filter3>
<cfset fval3  = attributes.filter3value>

<cfset start = "1">
<cfset new   = attributes.filter3value>
<cfloop condition="#start# lte #len(new)#">
		
		<cfif find("{","#new#",start)>
				
			<cfset str = find("{","#new#",start)>
			<cfset str = str+1>
			<cfset end = find("}","#new#",start)>
			<cfset end = end>
			
			<cfset fld = Mid(new, str, end-str)>
			<cfset fval3 = "'+document.getElementById('#fld#').value+'">			
						
			<cfset start = end>
			
		<cfelse>
		
			<cfset start = len(new)+1>	

		</cfif> 
	
</cfloop>		

<!--- ------------------------------------------ --->

<!--- ------------------------------------------ --->
<!--- retrieve value on the fly for the filter 4 --->
<!--- ------------------------------------------ --->

<cfset fil4   = attributes.filter4>
<cfset fval4  = attributes.filter4value>

<cfset start = "1">
<cfset new   = attributes.filter4value>
<cfloop condition="#start# lte #len(new)#">
		
		<cfif find("{","#new#",start)>
				
			<cfset str = find("{","#new#",start)>
			<cfset str = str+1>
			<cfset end = find("}","#new#",start)>
			<cfset end = end>
			
			<cfset fld = Mid(new, str, end-str)>
			<cfset fval4 = "'+document.getElementById('#fld#').value+'">			
						
			<cfset start = end>
			
		<cfelse>
		
			<cfset start = len(new)+1>	

		</cfif> 
	
</cfloop>		

<!--- ------------------------------------------ --->

<cfset link = replace(link,"&","||","ALL")> 

<cfif box eq "">
  No defined....
  <cfabort>
</cfif>

<cfoutput>

	<cfswitch expression="#class#">

		<cfcase value="Employee">	
		
			<CFParam name="Attributes.height" default="640">
			<CFParam name="Attributes.width" default="760">	
			
			<cfset jvlink = "try { ProsisUI.closeWindow('dialog#box#',true)} catch(e){};ProsisUI.createWindow('dialog#box#', 'Find Employee', '',{x:100,y:100,height:document.body.clientHeight-90,width:#Attributes.width#,resizable:false,modal:true,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Employee/Employee.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#&filter3=#fil3#&filter3value=#fval3#','dialog#box#')">		
				
			<cfif attributes.button eq "No">
			
				  <img src="#SESSION.root#/images/#attributes.icon#" name="icon#box#" id="icon#box#" 
					   style="#attributes.style#" 
					   alt="Select Person" 
					   border="0" 
					   align="absmiddle"
					   onMouseOver="document.icon#box#.src='#SESSION.root#/Images/contract.gif'" 
					   width="#attributes.iconwidth#"
				       height="#attributes.iconheight#"
					   onMouseOut="document.icon#box#.src='#SESSION.root#/Images/#icon#'"				   
					   onclick="#preservesinglequotes(jvlink)#" style="cursor:pointer">		
						
			<cfelse>
			
				 <img src="#SESSION.root#/Images/#icon#"
				      alt=""
				      name="icon#box#"
				      id="icon#box#"
				      width="#attributes.iconwidth#"
				      height="#attributes.iconheight#"		    
				      align="absmiddle"
				      style="#attributes.style#;border:0px solid silver; cursor: pointer; padding: 2px;"
				      onClick="#preservesinglequotes(jvlink)#"
				      onMouseOver="document.icon#box#.src='#SESSION.root#/Images/contract.gif'"
				      onMouseOut="document.icon#box#.src='#SESSION.root#/Images/#icon#'">
			
			</cfif>
			
		</cfcase>
		
		<cfcase value="Applicant">	
		
			<CFParam name="Attributes.height" default="640">
			<CFParam name="Attributes.width" default="760">	
			
			<cfset jvlink = "try { ProsisUI.closeWindow('dialog#box#',true)} catch(e){};ProsisUI.createWindow('dialog#box#', 'Natural Person', '',{x:100,y:100,height:document.body.clientHeight-90,width:#Attributes.width#,resizable:false,modal:true,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Applicant/Person.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#&filter3=#fil3#&filter3value=#fval3#','dialog#box#')">		
				
			<cfif attributes.button eq "No">
			
				  <img src="#SESSION.root#/images/#attributes.icon#" name="icon#box#" id="icon#box#" 
					   style="#attributes.style#" 
					   alt="Select Person" 
					   border="0" 
					   align="absmiddle"
					   onMouseOver="document.icon#box#.src='#SESSION.root#/Images/contract.gif'" 
					   width="#attributes.iconwidth#"
				       height="#attributes.iconheight#"
					   onMouseOut="document.icon#box#.src='#SESSION.root#/Images/#icon#'"				   
					   onclick="#preservesinglequotes(jvlink)#" style="cursor:pointer">		
						
			<cfelse>
			
				 <img src="#SESSION.root#/Images/#icon#"
				      alt=""
				      name="icon#box#"
				      id="icon#box#"
				      width="#attributes.iconwidth#"
				      height="#attributes.iconheight#"		    
				      align="absmiddle"
				      style="#attributes.style#;border:0px solid silver; cursor: pointer; padding: 2px;"
				      onClick="#preservesinglequotes(jvlink)#"
				      onMouseOver="document.icon#box#.src='#SESSION.root#/Images/contract.gif'"
				      onMouseOut="document.icon#box#.src='#SESSION.root#/Images/#icon#'">
			
			</cfif>
			
		</cfcase>
	
		<cfcase value="Role">	
		
			<CFParam name="Attributes.height" default="625">
			<CFParam name="Attributes.width"  default="620">			
		
			<cfset jvlink = "ProsisUI.createWindow('dialog#box#', 'Find Role', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,resizable:false,modal:true,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Role/Search.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">		
				    		
		 	<a href="javascript:#preservesinglequotes(jvlink)#">#Attributes.title#</a>			
				
		</cfcase>
	
		<cfcase value="Owner">	
	
			<CFParam name="Attributes.height" default="625">
			<CFParam name="Attributes.width"  default="620">	
				
			<cfset jvlink = "ProsisUI.createWindow('dialog#box#', 'Owner', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,resizable:false,modal:true,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Owner/Search.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">		
							   
		 	<a href="javascript:#preservesinglequotes(jvlink)#">#Attributes.title#</a>			
				
		</cfcase>
	
		<cfcase value="Template">	
		
			<CFParam name="Attributes.height" default="625">
			<CFParam name="Attributes.width"  default="620">	
		
			<cfset jvlink = "ColdFusion.Window.create('dialog#box#', 'Find Template', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,resizable:false,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Template/Template.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&&des2=#des2#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter1value=#fval2#','dialog#box#')">		
				
			<cfif attributes.button eq "No">
				    		
			 	<a style="cursor: pointer;" onClick="#preservesinglequotes(jvlink)#"><font color="0080FF">#Attributes.title#</font></a>
				
			<cfelse>
			
				 <img src="#SESSION.root#/Images/#icon#" alt="Select template" name="img99" 
						  onMouseOver="document.img99.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img99.src='#SESSION.root#/Images/#icon#'"
						  style="cursor: pointer;" alt="" width="14" height="16" border="0" align="absmiddle" 
						  onClick="#preservesinglequotes(jvlink)#">
			
			</cfif>
			
		</cfcase>		
		
		<cfcase value="User">	
				
			<CFParam name="Attributes.height" default="625">
			<CFParam name="Attributes.width"  default="680">	
			<cf_tl id="Find User Account" var="1">	
												
			<cfset jvlink = "try {ProsisUI.closeWindow('dialog#box#')} catch(e) {};ProsisUI.createWindow('dialog#box#', '#lt_text#', '',{x:100,y:100,height:document.body.clientHeight-80,width:#Attributes.width#,modal:true,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/User/User.cfm?form=#attributes.form#&close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#&filter3=#fil3#&filter3value=#fval3#','dialog#box#')">		
				
			<cfif attributes.button eq "No">
			
					 	<a href="javascript:#preservesinglequotes(jvlink)#">
						#Attributes.title#
						</a>
									
			<cfelse>
			
				 <img src="#SESSION.root#/Images/#icon#" alt="Select user" name="img99" 
						  onMouseOver="document.img99.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img99.src='#SESSION.root#/Images/#icon#'"
						  style="cursor: pointer;#attributes.style#" width="#attributes.iconwidth#" height="#attributes.iconheight#" border="0" align="absmiddle" 
						  onClick="#preservesinglequotes(jvlink)#">
														
			</cfif>	
		
		</cfcase>
	
		
		<cfcase value="UserGroup">	
		
			<CFParam name="Attributes.height" default="665">
			<CFParam name="Attributes.width"  default="690">			
				
			<cfset jvlink = "ProsisUI.createWindow('dialog#box#', 'User Group', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:true,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/UserGroup/UserGroup.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=&filter2value=','dialog#box#')">		
				
			<cfif attributes.button eq "No">
			
				<table><tr><td>
		    	<img src="#SESSION.root#/images/#icon#" alt="Click Here" border="0" align="absmiddle"
				onclick="#preservesinglequotes(jvlink)#" style="cursor: pointer;"></td>
				<td style="padding-left:5px">
				 	<a href="javascript:#preservesinglequotes(jvlink)#" >#Attributes.title#</a>
				</td></tr></table>
									
			<cfelse>
			
				<table><tr><td>
				 <img src="#SESSION.root#/Images/#icon#" alt="Select user group" name="img99" 
						  onMouseOver="document.img99.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img99.src='#SESSION.root#/Images/#icon#'"
						  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
						  onClick="#preservesinglequotes(jvlink)#"></td>
				<td style="padding-left:5px">		  
				 	<a href="javascript:#preservesinglequotes(jvlink)#" >#Attributes.title#</a>
				</td></tr></table>
								
			</cfif>	
		
		</cfcase>	
	
		<cfcase value="GLAccount">	
				
			<CFParam name="Attributes.height" default="625">
			<CFParam name="Attributes.width"  default="620">			
	
			<cfset jvlink = "ColdFusion.Window.create('dialog#box#', 'General Ledger Account', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:true,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/GLAccount/GLAccount.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=&filter2value=','dialog#box#')">		
				
			<cfif attributes.button eq "No">
			
		    	<img src="#SESSION.root#/images/#icon#" 
					alt="Click Here" 
					width="14" height="14" 
					border="0"
					align="absmiddle"
					onclick="#preservesinglequotes(jvlink)#"
					style="cursor:pointer">&nbsp;
					 	<a href="javascript:#preservesinglequotes(jvlink)#">				
						#Attributes.title#
						</a>
									
			<cfelse>
			
				 <img src="#SESSION.root#/Images/#icon#" alt="Select user" name="img99" id="img99"
						  onMouseOver="document.img99.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img99.src='#SESSION.root#/Images/#icon#'"
						  style="cursor: pointer" width="14" height="14" border="0" align="absmiddle" 
						  onClick="#preservesinglequotes(jvlink)#">
								
			</cfif>	
		
		</cfcase>	
	
		<cfcase value="Position">	
		
			<cfset returnlink = replace(link,"||","&")>
			
			<cfparam name="url.reqid" default="">
	
			<CFParam name="Attributes.height" default="790">
			<CFParam name="Attributes.width"  default="1180">	
				
			<cfset jvlink = "javascript:ptoken.open('#SESSION.root#/Tools/SelectLookup/Position/Position.cfm?reqid=#url.reqid#&close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#&filter3=#fil3#&filter3value=#fval3#&ts='+new Date().getTime(),'position','left=20, top=20, width=#Attributes.width#, height=#Attributes.height#, menubar=no, status=yes, toolbar=no, scrollbars=no, resizable=yes')">			
											
			<cfif attributes.button eq "No">
						
		    	<img src="#SESSION.root#/images/#attributes.icon#"  
			          id="img95"  name="img95"  
					  onMouseOver="document.img95.src='#SESSION.root#/Images/contract.gif'" 
					  onMouseOut="document.img95.src='#SESSION.root#/Images/#icon#'" 
					  style="border-radius:5px" 
					  alt="" 
					  border="0" 
					  width="#attributes.iconwidth#" 
					  height="#attributes.iconheight#" 
					  align="absmiddle"
					  onclick="#preservesinglequotes(jvlink)#" style="cursor: pointer;">&nbsp;
					  
					 	<a href="#preservesinglequotes(jvlink)#">#Attributes.title#</a>
				
			<cfelse>
			
				<input type="button" value="#Attributes.title#" class="button10s"
				    style="#attributes.style#;width:120px" onClick="#preservesinglequotes(jvlink)#">	
					
			</cfif>	
		
		</cfcase>
		
		<cfcase value="PositionSingle">	
		
			<CFParam name="Attributes.height" default="660">
			<CFParam name="Attributes.width"  default="680">		
		
			<cfset jvlink = "ProsisUI.createWindow('dialog#box#', '#Attributes.title#', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Position/PositionSingle.cfm?datasource=#attributes.datasource#&close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#&filter3=#fil3#&filter3value=#fval3#','dialog#box#')">		
							
			<cfif attributes.button eq "No">
						
					<img src="#SESSION.root#/images/#attributes.icon#" width="#attributes.iconwidth#"
				       height="#attributes.iconheight#" alt="" name="img63#box#"
				       id="img63#box#" border="0" align="absmiddle"
					   onMouseOver="document.img63#box#.src='#SESSION.root#/Images/contract.gif'"
				       onMouseOut="document.img63#box#.src='#SESSION.root#/Images/#icon#'"
					   onclick="#preservesinglequotes(jvlink)#" style="#attributes.style#;cursor:pointer">
						
			<cfelse>
			
				 <img src="#SESSION.root#/Images/#icon#"
				     alt=""
				     name="img91#box#"
				     id="img91#box#"
				     width="#attributes.iconwidth#"
				     height="#attributes.iconheight#"	    
				     align="absmiddle"
				     style="#attributes.style# border:0px solid silver; cursor: pointer; padding: 2px;"
				     onClick="#preservesinglequotes(jvlink)#"
				     onMouseOver="document.img91#box#.src='#SESSION.root#/Images/contract.gif'"
				     onMouseOut="document.img91#box#.src='#SESSION.root#/Images/#icon#'">
				
			</cfif>	
		
		</cfcase>
	
		<cfcase value="Function">	
		
			<CFParam name="Attributes.height" default="600">
			<CFParam name="Attributes.width"  default="540">			
		
			<cfset jvlink = "ProsisUI.createWindow('dialog#box#', '#Attributes.title#', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:true,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Function/Function.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">		
				
			<cfif attributes.button eq "No">
			
				<img src="#SESSION.root#/images/#attributes.icon#" width="#attributes.iconwidth#"
				       height="#attributes.iconheight#" alt="" name="img64#box#"
				       id="img64#box#" border="0" align="absmiddle"
					   onMouseOver="document.img64#box#.src='#SESSION.root#/Images/contract.gif'"
				       onMouseOut="document.img64#box#.src='#SESSION.root#/Images/#icon#'"
					   onclick="#preservesinglequotes(jvlink)#" style="#attributes.style#;cursor:pointer">	    						 	
				
			<cfelse>
			
				 <img src="#SESSION.root#/Images/#attributes.icon#" alt="Select user" name="img99" width="#attributes.iconwidth#"
				     height="#attributes.iconheight#"
						  onMouseOver="document.img99.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img99.src='#SESSION.root#/Images/#attributes.icon#'"
						  style="cursor: pointer;" alt=""  border="0" align="absmiddle" 
						  onClick="#preservesinglequotes(jvlink)#">
				
			
			</cfif>	
		
		</cfcase>
	
		<cfcase value="Standard">	
		
			<CFParam name="Attributes.height" default="600">
			<CFParam name="Attributes.width"  default="540">			
			
			<cfset jvlink = "ProsisUI.createWindow('dialog#box#', '#Attributes.title#', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:true,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Standard/Standard.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">		
				
			<cfif attributes.button eq "No">
			
		    	<img src="#SESSION.root#/images/#attributes.icon#" alt="" border="0" align="absmiddle"
				onclick="#preservesinglequotes(jvlink)#" style="cursor: pointer;" width="11" height="11">&nbsp;
					 	<a href="javascript:#preservesinglequotes(jvlink)#">						
						#Attributes.title#</a>
				
			<cfelse>
			
				 <img src="#SESSION.root#/Images/#attributes.icon#" alt="Select standard" name="img99" 
					  onMouseOver="document.img99.src='#SESSION.root#/Images/contract.gif'" 
					  onMouseOut="document.img99.src='#SESSION.root#/Images/#attributes.icon#'"
					  style="cursor: pointer;" alt="" width="11" height="11" border="0" align="absmiddle" 
					  onClick="#preservesinglequotes(jvlink)#">
						  
					  <a href="javascript:#preservesinglequotes(jvlink)#">#Attributes.title#</a>
			
			</cfif>	
		
		</cfcase>
	
		<cfcase value="Object">	
	
			<CFParam name="Attributes.height" default="600">
			<CFParam name="Attributes.width"  default="540">			
				
			<cfset jvlink = "ProsisUI.createWindow('dialog#box#', '#Attributes.title#', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:true,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Object/Object.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">		
				
			<cfif attributes.button eq "No">
			
		    	<img src="#SESSION.root#/images/#attributes.icon#" alt="" width="11" height="11" border="0" align="absmiddle"
				onclick="#preservesinglequotes(jvlink)#" style="cursor: pointer;">&nbsp;
					 	<a href="javascript:#preservesinglequotes(jvlink)#">						
						#Attributes.title#</a>
				
			<cfelse>
			
				 <img src="#SESSION.root#/Images/#attributes.icon#" alt="Select user" name="img99" 
						  onMouseOver="document.img99.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img99.src='#SESSION.root#/Images/#attributes.icon#'"
						  style="cursor: pointer;" alt="" width="11" height="11" border="0" align="absmiddle" 
						  onClick="#preservesinglequotes(jvlink)#">
						  
						  <a href="javascript:#preservesinglequotes(jvlink)#">#Attributes.title#</a>
			
			</cfif>	
		
		</cfcase>
	
		<cfcase value="ItemMaster">	
			
			<CFParam name="Attributes.height" default="600">
			<CFParam name="Attributes.width"  default="540">		
				
			<cfset jvlink = "ColdFusion.Window.create('dialog#box#','#Attributes.title#','',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:false,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/ItemMaster/Item.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">		
				
			<cfif attributes.button eq "No">
			
		    	<img src="#CLIENT.virtualdir#/images/#attributes.icon#" width="11" height="11" alt="" border="0" align="absmiddle"
				onclick="#preservesinglequotes(jvlink)#" style="cursor: pointer;">&nbsp;
					 	<a href="javascript:#preservesinglequotes(jvlink)#">
						<font color="4FA7FF">
						#Attributes.title#</a>
				
			<cfelse>
			
				 <img src="#CLIENT.virtualdir#/Images/#attributes.icon#" alt="Select user" name="img97" 
						  onMouseOver="document.img97.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img97.src='#SESSION.root#/Images/#attributes.icon#'"
						  style="cursor: pointer;" alt="" width="11" height="11" border="0" align="absmiddle" 
						  onClick="#preservesinglequotes(jvlink)#">
						 		
			</cfif>	
		
		</cfcase>
		
		<cfcase value="ItemStock">			
				
			<CFParam name="Attributes.height" default="620">
			<CFParam name="Attributes.width"  default="700">		
				
			<cfset jvlink = "ProsisUI.createWindow('dialog#box#','#Attributes.title#','',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Item/Item.cfm?stock=1&close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">		
								
			<cfif attributes.button eq "cfbutton">	
					
				<cf_button2
					text        = "#Attributes.title#" 
                    subText     = "#Attributes.buttonlayout.subText#"
                    image       = "#attributes.buttonlayout.image#"  
                    onclick		= "#preservesinglequotes(jvlink)#" 	
                    width       = "#attributes.buttonlayout.width#" 
					textcolor   = "#attributes.buttonlayout.textcolor#"
					textsize    = "#attributes.buttonlayout.textsize#"	
                    height      = "#attributes.buttonlayout.height#"
					bgColor     = "#attributes.buttonlayout.bgColor#"
					borderColor = "#attributes.buttonlayout.borderColor#"
					borderRadius= "#attributes.buttonlayout.borderRadius#"
                    imageHeight = "#attributes.buttonlayout.imageHeight#"
                    imagePos    = "#attributes.buttonlayout.imagePos#"
					title       = "#attributes.title#">
												
			<cfelseif attributes.button eq "No">
			
			     <table cellspacing="0" cellpadding="0">
			      <tr><td>
				   <img src="#CLIENT.virtualdir#/images/#attributes.icon#" width="#attributes.iconwidth#" height="#attributes.iconheight#" 
				    alt="" border="0" align="absmiddle"
					onclick="#preservesinglequotes(jvlink)#" style="cursor: pointer;">
					</td>
					<cfif attributes.title neq "">
					<td style="padding-left:8px">
				 		<a href="javascript:#preservesinglequotes(jvlink)#">#Attributes.title#</a>
					</td>
					</cfif>
					</tr>
				</table>	
							
			<cfelse>
			
				 <img src="#CLIENT.virtualdir#/Images/#attributes.icon#" alt="Select Item" name="img#attributes.box#" 
						  onMouseOver="document.img#attributes.box#.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img#attributes.box#.src='#SESSION.root#/Images/#attributes.icon#'"
						  style="cursor: pointer;" alt="" width="#attributes.iconwidth#" height="#attributes.iconheight#" border="0" align="absmiddle" 
						  onClick="#preservesinglequotes(jvlink)#">
						 		
			</cfif>	
		
		</cfcase>
	
		<cfcase value="Item">			
				
			<CFParam name="Attributes.height" default="620">
			<CFParam name="Attributes.width"  default="800">		
				
			<cfset jvlink = "ProsisUI.createWindow('dialog#box#','#Attributes.title#','',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Item/Item.cfm?stock=0&close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">		
				
			<cfif attributes.button eq "cfbutton">				
				
				<cf_button2
					text        = "#Attributes.title#" 
                    subText     = "#Attributes.buttonlayout.subText#"
                    image       = "#attributes.buttonlayout.image#"  
                    onclick		= "#preservesinglequotes(jvlink)#" 	
                    width       = "#attributes.buttonlayout.width#" 
					textcolor   = "#attributes.buttonlayout.textcolor#"
					textsize    = "#attributes.buttonlayout.textsize#"	
                    height      = "#attributes.buttonlayout.height#"
					bgColor     = "#attributes.buttonlayout.bgColor#"
					borderColor = "#attributes.buttonlayout.borderColor#"
					borderRadius= "#attributes.buttonlayout.borderRadius#"
                    imageHeight = "#attributes.buttonlayout.imageHeight#"
                    imagePos    = "#attributes.buttonlayout.imagePos#"
					title       = "#attributes.title#">
												
			<cfelseif attributes.button eq "No">
			
			     <table cellspacing="0" cellpadding="0">
			      <tr><td>
				   <img src="#CLIENT.virtualdir#/images/#attributes.icon#" width="#attributes.iconwidth#" height="#attributes.iconheight#" 
				    alt="" border="0" align="absmiddle"
					onclick="#preservesinglequotes(jvlink)#" style="cursor: pointer;">
					</td>
					<cfif attributes.title neq "">
					<td style="padding-left:8px">
				 	<a href="javascript:#preservesinglequotes(jvlink)#">#Attributes.title#</a>
					</td>
					</cfif>
					</tr>
				</table>	
							
			<cfelse>
			
				 <img src="#CLIENT.virtualdir#/Images/#attributes.icon#" alt="Select Item" name="img#attributes.box#" 
						  onMouseOver="document.img#attributes.box#.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img#attributes.box#.src='#SESSION.root#/Images/#attributes.icon#'"
						  style="cursor: pointer;" alt="" width="#attributes.iconwidth#" height="#attributes.iconheight#" border="0" align="absmiddle" 
						  onClick="#preservesinglequotes(jvlink)#">
						 		
			</cfif>	
		
		</cfcase>
		
		<!--- graphic presentation --->
		
		<cfcase value="ItemExtended">	
		
			<CFParam name="Attributes.height"    default="600">
			<CFParam name="Attributes.width"     default="540">	
			<CFParam name="Attributes.pFunction"  default="">	
			
			<cfset jvlink = "#pfunction#;ProsisUI.createWindow('dialog#box#','#Attributes.title#','',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-80,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/ItemExtended/Item.cfm?getform=#attributes.formname#&module=#attributes.module#&width='+document.body.clientWidth+'&close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#');">		
						
			<cfif attributes.button eq "cfbutton">	
							
				<cf_button2
					text        = "#Attributes.title#" 
                    subText     = "#Attributes.buttonlayout.subText#"
                    image       = "#attributes.buttonlayout.image#"  
                    onclick		= "#preservesinglequotes(jvlink)#" 	
                    width       = "#attributes.buttonlayout.width#" 
					textcolor   = "#attributes.buttonlayout.textcolor#"
					textsize    = "#attributes.buttonlayout.textsize#"	
                    height      = "#attributes.buttonlayout.height#"
					bgColor     = "#attributes.buttonlayout.bgColor#"
					borderColor = "#attributes.buttonlayout.borderColor#"
					borderRadius= "#attributes.buttonlayout.borderRadius#"
                    imageHeight = "#attributes.buttonlayout.imageHeight#"
                    imagePos    = "#attributes.buttonlayout.imagePos#"
					title       = "#attributes.title#">
	

					
			<cfelseif attributes.button eq "No">
			
			   <table cellspacing="0" cellpadding="0">
			   <tr><td>
			   
		    	<img src="#CLIENT.virtualdir#/images/#attributes.icon#" width="#attributes.iconwidth#" height="#attributes.iconheight#" 
				    alt="" border="0" align="absmiddle"
					onclick="#preservesinglequotes(jvlink)#" style="cursor: pointer;">
					</td>
					
					<cfif attributes.title neq "">
					<td style="padding-left:8px">
				 	<a href="javascript:#preservesinglequotes(jvlink)#"><font  face="Calibri" size="2">#Attributes.title#</a>
					</td></cfif>
					
					</td></tr>
				</table>
				
			<cfelse>
			
				 <input type="button" value="#Attributes.title#" class="button10s"
				    style="#attributes.style#;width:120px" onClick="#preservesinglequotes(jvlink)#">	
										 		
			</cfif>	
		
		</cfcase>
		
		<!--- graphic presentation --->
		
		<cfcase value="SalesOrder">	
		
			<CFParam name="Attributes.height"     default="600">
			<CFParam name="Attributes.width"      default="640">	
			<CFParam name="Attributes.pFunction"   default="">		
						
			<cfset jvlink = "#pfunction#;try { ProsisUI.createWindow('dialog#box#') } catch(e) { ProsisUI.createWindow('dialog#box#','#Attributes.title#','',{x:100,y:100,height:document.body.clientHeight-70,width:document.body.clientWidth-90,modal:#attributes.modal#,center:true}) };ptoken.navigate('#SESSION.root#/Tools/SelectLookup/SalesOrder/Sale.cfm?module=#attributes.module#&width='+document.body.clientWidth+'&close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">		
						
			<cfif attributes.button eq "cfbutton">
								
				<cf_button2
					text        = "#Attributes.title#" 
                    subText     = "#Attributes.buttonlayout.subText#"
                    image       = "#attributes.buttonlayout.image#"  
                    onclick		= "#preservesinglequotes(jvlink)#" 	
                    width       = "#attributes.buttonlayout.width#" 
					textcolor   = "#attributes.buttonlayout.textcolor#"
					textsize    = "#attributes.buttonlayout.textsize#"	
                    height      = "#attributes.buttonlayout.height#"
					bgColor     = "#attributes.buttonlayout.bgColor#"
					borderColor = "#attributes.buttonlayout.borderColor#"
					borderRadius= "#attributes.buttonlayout.borderRadius#"
                    imageHeight = "#attributes.buttonlayout.imageHeight#"
                    imagePos    = "#attributes.buttonlayout.imagePos#"
					title       = "#attributes.title#">
				
			<cfelseif attributes.button eq "No">
						
			   <table cellspacing="0" cellpadding="0">
			   <tr><td>
			   
		    	<img src="#CLIENT.virtualdir#/images/#attributes.icon#" width="#attributes.iconwidth#" height="#attributes.iconheight#" 
				    alt="" border="0" align="absmiddle"
					onclick="#preservesinglequotes(jvlink)#" style="cursor: pointer;">
					</td>
					
					<cfif attributes.title neq "">
					<td style="padding-left:8px">
				 	<a href="javascript:#preservesinglequotes(jvlink)#"><font  face="Calibri" size="2">#Attributes.title#</a>
					</td></cfif>
					
					</td></tr>
				</table>
				
			<cfelse>
			
				 <input type="button" value="#Attributes.title#" class="button10s"
				    style="#attributes.style#;width:120px" onClick="#preservesinglequotes(jvlink)#">	
										 		
			</cfif>	
		
		</cfcase>
	
		<cfcase value="Asset">	
		
			<CFParam name="Attributes.height" default="600">
			<CFParam name="Attributes.width"  default="740">		
					
			<cfset jvlink = "ProsisUI.createWindow('dialog#box#','#Attributes.title#','',{x:100,y:100,height:document.body.clientHeight-160,width:#Attributes.width#,modal:true,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Asset/Item.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#&filter3=#fil3#&filter3value=#fval3#&filter4=#fil4#&filter4value=#fval4#','dialog#box#')">		
				
			<cfif attributes.button eq "No">
			
			 	<img src="#SESSION.root#/images/#attributes.icon#"  width="#attributes.iconwidth#"
				       height="#attributes.iconheight#" alt="Select Asset Item" name="img79"
				     id="img79" border="0" align="absmiddle"
					 onclick="#preservesinglequotes(jvlink)#" style="cursor:pointer" onMouseOver="document.img79.src='#SESSION.root#/Images/contract.gif'"
				     onMouseOut="document.img79.src='#SESSION.root#/Images/#attributes.icon#'">
							 				
			<cfelse>
			
				<input type="button" value="..." class="button10g" style="#attributes.style#" onClick="#preservesinglequotes(jvlink)#">	
								  					 		
			</cfif>	
		
		</cfcase>
	
		<cfcase value="Warehouse">	
		
			<CFParam name="Attributes.height" default="600">
			<CFParam name="Attributes.width"  default="740">		
		
			<cfset jvlink = "ColdFusion.Window.create('dialog#box#','#Attributes.title#','',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:false,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Warehouse/Warehouse.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">		
				
			<cfif attributes.button eq "No">
			
			 	<img src="#SESSION.root#/images/#attributes.icon#" width="17" height="18" alt="" name="img79"
				     id="img77" border="0" align="absmiddle"
					 onclick="#preservesinglequotes(jvlink)#" style="cursor:pointer" onMouseOver="document.img77.src='#SESSION.root#/Images/contract.gif'"
				     onMouseOut="document.img77.src='#SESSION.root#/Images/#attributes.icon#'">
							 				
			<cfelse>
			
				<input type="button" value="Select Warehouse Location" class="button10s" style="#attributes.style#;width:120px" onClick="#preservesinglequotes(jvlink)#">	
								  					 		
			</cfif>	
		
		</cfcase>	
	
		<cfcase value="Organization">	
			
			<CFParam name="Attributes.height" default="630">
			<CFParam name="Attributes.width"  default="625">		
		
			<cfset jvlink = "try { ProsisUI.closeWindow('dialog#box#',true)} catch(e){};ProsisUI.createWindow('dialog#box#', '#Attributes.title#', '',{x:100,y:100,height:document.body.clientHeight-90,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Unit/Organization.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">		
				
			<cfif attributes.button eq "No">
			
			    <table cellspacing="0" cellpadding="0"><tr><td>
				
					<img src="#SESSION.root#/images/#attributes.icon#" 
						width="#attributes.iconwidth#"
				        height="#attributes.iconheight#"
					    alt="Select Unit" 
						name="img59" id="img59" 
						border="0" 
						align="absmiddle"	
						onclick="#preservesinglequotes(jvlink)#" 
						style="cursor:pointer" 
						onMouseOver="document.img59.src='#SESSION.root#/Images/contract.gif'"
				        onMouseOut="document.img59.src='#SESSION.root#/Images/#attributes.icon#'">
												
					</td>									
					</tr>
					
				</table>
								
			<cfelse>
			
				<input type="button" value="#Attributes.title#" class="button10s"
				    style="#attributes.style#;width:120px" onClick="#preservesinglequotes(jvlink)#">			
			    		
			</cfif>			
		
		</cfcase>
	
		<cfcase value="Customer">	
		
			<CFParam name="Attributes.height" default="660">
			<CFParam name="Attributes.width"  default="780">		
							
			<cfset jvlink = "ProsisUI.createWindow('dialog#box#', '#Attributes.title#', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Customer/Customer.cfm?datasource=#attributes.datasource#&close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">		
							
			<cfif attributes.button eq "No">
			
					<img src="#SESSION.root#/images/#attributes.icon#" width="#attributes.iconwidth#"
				       height="#attributes.iconheight#" alt="" name="img69#box#"
				       id="img69#box#" border="0" align="absmiddle"
					   onclick="#preservesinglequotes(jvlink)#" style="#attributes.style#;cursor:pointer" onMouseOver="document.img69#box#.src='#SESSION.root#/Images/contract.gif'"
				       onMouseOut="document.img69#box#.src='#SESSION.root#/Images/#attributes.icon#'">
						
			<cfelse>
			
				 <img src="#SESSION.root#/Images/#icon#"
				     alt=""
				     name="img91#box#"
				     id="img91#box#"
				     width="#attributes.iconwidth#"
				     height="#attributes.iconheight#"	    
				     align="absmiddle"
				     style="#attributes.style# border:0px solid silver; cursor: pointer; padding: 2px;"
				     onClick="#preservesinglequotes(jvlink)#"
				     onMouseOver="document.img91#box#.src='#SESSION.root#/Images/contract.gif'"
				     onMouseOut="document.img91#box#.src='#SESSION.root#/Images/#icon#'">
						
			
			</cfif>	
		
		</cfcase>
		
		<cfcase value="Tax">	
		
			<CFParam name="Attributes.height" default="660">
			<CFParam name="Attributes.width"  default="780">		
		
			<cfset jvlink = "ProsisUI.createWindow('dialog#box#', '#Attributes.title#', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/TaxCode/Tax.cfm?datasource=#attributes.datasource#&close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">		
							
			<cfif attributes.button eq "No">
			
					<img src="#SESSION.root#/images/#attributes.icon#" width="#attributes.iconwidth#"
				       height="#attributes.iconheight#" alt="" name="img69#box#"
				       id="img69#box#" border="0" align="absmiddle"
					   onclick="#preservesinglequotes(jvlink)#" style="#attributes.style#;cursor:pointer" onMouseOver="document.img69#box#.src='#SESSION.root#/Images/contract.gif'"
				       onMouseOut="document.img69#box#.src='#SESSION.root#/Images/#attributes.icon#'">
						
			<cfelse>
			
				 <img src="#SESSION.root#/Images/#icon#"
				     alt=""
				     name="img91#box#"
				     id="img91#box#"
				     width="#attributes.iconwidth#"
				     height="#attributes.iconheight#"	    
				     align="absmiddle"
				     style="#attributes.style# border:0px solid silver; cursor: pointer; padding: 2px;"
				     onClick="#preservesinglequotes(jvlink)#"
				     onMouseOver="document.img91#box#.src='#SESSION.root#/Images/contract.gif'"
				     onMouseOut="document.img91#box#.src='#SESSION.root#/Images/#icon#'">
						
			
			</cfif>	
		
		</cfcase>
					
		<cfcase value="Workorder">			
		
			<CFParam name="Attributes.height" default="625">
			<CFParam name="Attributes.width"  default="620">		
		
			<cfset jvlink = "ColdFusion.Window.create('dialog#box#', '#Attributes.title#', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/WorkOrder/Search.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#&filter3=#fil3#&filter3value=#fval3#','dialog#box#')">		
					
			<cfif attributes.button eq "No">
					
		    	<img src="#SESSION.root#/images/#attributes.icon#" width="#attributes.iconwidth#"
				       height="#attributes.iconheight#" style="#attributes.style#" alt="Select" border="0" align="absmiddle"
				onclick="#preservesinglequotes(jvlink)#" style="cursor:pointer">&nbsp;
					 	
				<a href="javascript:#preservesinglequotes(jvlink)#"><font id="#attributes.id#">#Attributes.title#</font></a>
				
			<cfelse>
											
				<img src="#SESSION.root#/Images/#icon#"
				     alt=""
				     name="img99"
				     id="img99"
				     width="#attributes.iconwidth#"
				     height="#attributes.iconheight#"	    
				     align="absmiddle"
				     style="#attributes.style# border:0px solid silver; cursor: pointer; padding: 2px;"
				     onClick="#preservesinglequotes(jvlink)#"
				     onMouseOver="document.img99.src='#SESSION.root#/Images/contract.gif'"
				     onMouseOut="document.img99.src='#SESSION.root#/Images/#icon#'">
						
			
			</cfif>	
		
		</cfcase>
	
		<cfcase value="WorkorderLine">			
		
			<CFParam name="Attributes.height" default="625">
			<CFParam name="Attributes.width"  default="620">		
	
			<cfset jvlink = "ColdFusion.Window.create('dialog#box#', '#Attributes.title#', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/WorkOrderLine/Search.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#&filter3=#fil3#&filter3value=#fval3#','dialog#box#')">		
					
			<cfif attributes.button eq "No">
					
		    	<img src="#SESSION.root#/images/#attributes.icon#" 
				  style="#attributes.style#" 
				  alt="Select Unit" 
				  border="0" 
				  align="absmiddle"
				  onclick="#preservesinglequotes(jvlink)#" 
				  style="cursor:pointer">&nbsp;
					 	
				<a href="javascript:#preservesinglequotes(jvlink)#">#Attributes.title#</a>
				
			<cfelse>
					
				<img src="#SESSION.root#/Images/#icon#"
				     alt=""
				     name="img99"
				     id="img99"
				     width="#attributes.iconwidth#"
				     height="#attributes.iconheight#"	    
				     align="absmiddle"
				     style="#attributes.style#;border:0px solid silver; cursor: pointer; padding: 2px;"
				     onClick="#preservesinglequotes(jvlink)#"
				     onMouseOver="document.img99.src='#SESSION.root#/Images/contract.gif'"
				     onMouseOut="document.img99.src='#SESSION.root#/Images/#icon#'">
						
			
			</cfif>	
		
		</cfcase>
	
		<cfcase value="Tree">	
		
			<CFParam name="Attributes.height" default="625">
			<CFParam name="Attributes.width"  default="620">		
		
			<cfset jvlink = "ColdFusion.Window.create('dialog#box#', '#Attributes.title#', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Tree/Tree.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">		
				
			<cfif attributes.button eq "No">
			
				 	<img src="#SESSION.root#/images/#attributes.icon#" width="#attributes.iconwidth#"
				     height="#attributes.iconheight#" alt="" name="img89"
				     id="img89" border="0" align="absmiddle"
					onclick="#preservesinglequotes(jvlink)#" style="cursor:pointer" onMouseOver="document.img89.src='#SESSION.root#/Images/contract.gif'"
				     onMouseOut="document.img89.src='#SESSION.root#/Images/#attributes.icon#'">
						
			<cfelse>
			
				 <img src="#SESSION.root#/Images/#attributes.icon#" alt="Select Unit" name="img99" 
						  onMouseOver="document.img99.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img99.src='#SESSION.root#/Images/#attributes.icon#'"
						  style="#attributes.style#;cursor: pointer;" alt="" width="#attributes.iconwidth#"
					      height="#attributes.iconheight#" border="0" align="absmiddle" 
						  onClick="#preservesinglequotes(jvlink)#">						  
						  <a href="javascript:#preservesinglequotes(jvlink)#">#Attributes.title#</a>
			
			</cfif>	
		
		</cfcase>
	
		<cfcase value="Funding">	
		
			<CFParam name="Attributes.height" default="625">
			<CFParam name="Attributes.width"  default="620">			
		
			<cfset jvlink = "ColdFusion.Window.create('dialog#box#', 'Find Funding', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,resizable:false,modal:true,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Funding/Funding.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filtervalue=#fval1#','dialog#box#')">		
				
			<cfif attributes.button eq "No">
			
		    		<img src="#SESSION.root#/images/#icon#" alt="Click Here" width="#attributes.iconwidth#"
				        height="#attributes.iconheight#" border="0" align="absmiddle"
				       onclick="#preservesinglequotes(jvlink)#" style="cursor: pointer;">&nbsp;
					 	<a href="javascript:#preservesinglequotes(jvlink)#">#Attributes.title#</a>
				
			<cfelse>
						
				 <img src="#SESSION.root#/Images/#icon#"
			     alt=""
			     name="img73"
			     id="img73"
			     width="#attributes.iconwidth#"
				 height="#attributes.iconheight#"	    
			     align="absmiddle"
			     style="#attributes.style#;border:0px solid silver; cursor: pointer;"
			     onClick="#preservesinglequotes(jvlink)#"
			     onMouseOver="document.getElementById('img73').src='#SESSION.root#/Images/contract.gif'"
			     onMouseOut="document.getElementById('img73').src='#SESSION.root#/Images/#icon#'">
			
			</cfif>
			
		</cfcase>
	
		<cfcase value="Mission">	
		
			<CFParam name="Attributes.height" default="430">
			<CFParam name="Attributes.width"  default="590">			
				
			<cfset jvlink = "ProsisUI.createWindow('dialog#box#', 'Search Entity', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,resizable:false,modal:true,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Mission/Search.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filtervalue1=#fval1#','dialog#box#')">
				
			<cfif attributes.button eq "No">
					    		
					<a href="javascript:#preservesinglequotes(jvlink)#">#Attributes.title#</a>
				
			<cfelse>
			
				 <img src="#SESSION.root#/Images/#icon#"
			     alt="" id="img23"
				 width="#attributes.iconwidth#"
			     height="#attributes.iconheight#"				    	    
			     align="absmiddle"
			     style="#attributes.style#;border:1px solid silver; cursor: pointer; padding: 2px;"
			     onClick="#preservesinglequotes(jvlink)#"
			     onMouseOver="document.img23.src='#SESSION.root#/Images/contract.gif'"
			     onMouseOut="document.img23.src='#SESSION.root#/Images/#icon#'">
			
			</cfif>
			
		</cfcase>
		
		<cfcase value="ItemOneClick">	
		
			<CFParam name="Attributes.height" default="620">
			<CFParam name="Attributes.width"  default="550">			
				
			<cfset jvlink = "ColdFusion.Window.create('dialog#box#', 'Item Search', '',{x:100,y:100,height:#Attributes.height#,width:#Attributes.width#,resizable:false,modal:true,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/ItemOneClick/Search.cfm?close=#attributes.close#&class=#class#&box=#box#&link=#link#&dbtable=#dbtable#&des1=#des1#&filter1=#fil1#&filter1value=#fval1#&filter2=#fil2#&filter2value=#fval2#','dialog#box#')">
				
			<cfif attributes.button eq "No">
			
		    		<img src="#SESSION.root#/images/#icon#" title="Select items" width="#attributes.iconwidth#"
				     height="#attributes.iconheight#"	 border="0" align="absmiddle"
				       onclick="#preservesinglequotes(jvlink)#" style="cursor: pointer;">&nbsp;
					 	<a href="javascript:#preservesinglequotes(jvlink)#">#Attributes.title#</a>
				
			<cfelse>
				 
				 <input class="button10g" 
				 		style="width:160px;height:21" 
						type="Button" 
						name="ItemOneClickAdd" 
						id="ItemOneClickAdd" 
						value="#Attributes.title#" 
						onclick="#preservesinglequotes(jvlink)#">
			
			</cfif>
			
		</cfcase>
	
	</cfswitch>

</cfoutput>
	     

