xquery version "3.0";

import module namespace functx="http://www.functx.com" at '/db/core/library/functx/functx.xq';

let $conf := doc('../../../conf.xml')

let $x:=util:import-module($conf/config/appServices/service[@name="locator"]/nameSpace,"locator",$conf/config/appServices/service[@name="locator"]/location)
let $screeningProcess := util:eval("locator:getDataPath('patientManagement')")

let $patientscreeningProcess := util:eval("locator:getDataPath('requestScreening')")

 let $post-data := 
(: <data>:)
(:<parameter name="dummy" value="Screening"></parameter>:)
(:<parameter name="patientId" value="PC1710051"></parameter>:)
(:</data>:)
request:get-data()

let $patientid:=$post-data//parameter[@name='patientId']/@value

 return
     <data>{
     for $data in collection($screeningProcess)/patientInfo
     where $data//patientId=$patientid 
     return  
         <screeningProcess>
        <active/>
         <patient id="{$data//patientId}" name="{$data//name}"></patient> 
         {$data//image}
         {$data//dob}
          {$data//age}
           {$data/gender}
            {$data//bloodGroup}
            {$data/contactNo}
            {$data//doctor}
             {$data//maritalStatus}             
            {
                
                        for $request in collection($patientscreeningProcess)/screeningprocess
                        where $request//patient/string(@id)= $patientid
                        return
                            <test>
                            <requestScreenings><date>{substring($request//requestScreenings/@dateTime,1,10)}</date><Time>{substring($request//requestScreenings/@dateTime,12,5)}</Time>
                             {$request//requestScreenings/screening}
                             </requestScreenings>
                           {$request//status}
                            </test>
                            
            }                
    </screeningProcess>
    
     }</data>
