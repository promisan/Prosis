
<cfparam name="attributes.text" default="bab63f8e607c6f0323822c3e8f0732a5">
<cfparam name="attributes.algo" default="AES">
<cfparam name="attributes.enco" default="UU">

<cfset ALGO  = "#Attributes.algo#"> 
<cfset ENCO  = "#Attributes.enco#"> 

<cfset OUT="#Attributes.Text#"> 
	
<cfset TEXT="#Attributes.Text#"> 

<cfif ALGO eq "AES">
	<cfset Seed="TE1AWHCQJ+SUZyJTVZWyoQ=="> 
<cfelseif ALGO eq "DES">
    <cfset Seed="tebjuhzlwsg="> 
</cfif>	

<cfset Caller.Decrypted = Decrypt(text,seed,algo,enco)>	