
<cfparam name="attributes.algo" default="AES">
<cfparam name="attributes.enco" default="UU">

<cfset TEXT  = "#Attributes.Text#"> 
<cfset ALGO  = "#Attributes.algo#"> 
<cfset ENCO  = "#Attributes.enco#"> 

<cfset TEXT="#Attributes.Text#"> 

<cfif ALGO eq "AES">
	<cfset Seed="TE1AWHCQJ+SUZyJTVZWyoQ=="> 
<cfelseif ALGO eq "DES">
    <cfset Seed="tebjuhzlwsg="> 
</cfif>	

<cfif text neq "">
	<cfset Caller.EncryptedText = Encrypt(text,seed,algo,enco)> 	
<cfelse>
    <cfset Caller.EncryptedText = "">
</cfif>	


	
		
	