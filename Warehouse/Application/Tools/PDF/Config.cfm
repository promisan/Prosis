<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<config xmlns="http://www.xfa.org/schema/xci/2.6/">
   <agent name="designer">
      <!--  [0..n]  -->
      <destination>pdf</destination>
      <pdf>
         <!--  [0..n]  -->
         <fontInfo/>
      </pdf>
   </agent>
   <present>
      <!--  [0..n]  -->
      <pdf>
         <!--  [0..n]  -->
         <version>1.7</version>
         <adobeExtensionLevel>1</adobeExtensionLevel>
      </pdf>
      <common/>
      <script>
         <runScripts>server</runScripts>
      </script>
      <xdp>
         <packets>*</packets>
      </xdp>
   </present>
   <psMap>
      <font typeface="Calibri" psName="Calibri" weight="normal" posture="normal"/>
   </psMap>
</config>
