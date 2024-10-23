*** Settings ***
Library         SeleniumLibrary
Library         OperatingSystem
Library         BuiltIn
Library         String
Library         Math

*** Variables ***
${tax}  8.0
&{product_sauce_labs_bike_light}    title=Sauce Labs Bike Light      price=9.99    
&{product_sauce_labs_bolt_t-Shirt}    title=Sauce Labs Bolt T-Shirt    price=15.99   



*** Keywords ***


*** Test Cases ***
TC_01 
#step 0: Open
    Open Browser    https://www.saucedemo.com/ 	chrome	 options=add_experimental_option("detach", True) 

    #step 0.1: Verify that Swag labs is show
    #Page Should Contain Element      //div[@class='login_logo'][text()='Swag Labs']           #ตรวจสอบ Element   
    Wait Until Element Is Visible      //div[@class='login_logo'][text()='Swag Labs']           #รอจนกว่า Element จะแสดง      
    Element Text Should Be      xpath= //div[@class='login_logo']   expected=Swag Labs              #ตรวจสอบ Text

    #step 0.2: Verify that Username is show
    Wait Until Element Is Visible  xpath=//input[@id='user-name']    10s

    #step 0.3: Verify that Password is show
    Wait Until Element Is Visible  xpath=//input[@id='password']     10s

    #step 0.4: Verify that Login button is show
    Page Should Contain Element     xpath=//input[@id="login-button"]     10s
    
#step 1: Login
    #step 1.1: input username
    input Text      id= user-name   standard_user
    
    #step 1.1.1: Verify that input username has a value
    Textfield Should Contain    id= user-name   standard_user   # ตรวจสอบText ที่กรอกไปแล้วใน username
    Element Attribute Value Should Be     id= user-name    value        standard_user   # แบบ 1 ตรวจสอบ Value ที่กรอกไปแล้วใน username
    ${user}     Get Element Attribute       id= user-name   value                       # แบบ 2 ตรวจสอบอีกแบบ แบบเก็บค่า value ในตัวแปร และเอาไปเทียบ
    Should Be Equal     ${user}     standard_user                                       # ต่อแบบ 2    เทียบ  value = คำที่ถูกต้อง

    Page Should Contain Element     //input[@id='user-name'][@value='standard_user']    # แบบ 3 ตรวจสอบ Value 
    Textfield Value Should Be       //input[@id='user-name']    standard_user           # แบบ 4 ตรวจสอบ Value  ใช้อันนี้เป็นหลัก******
    
    Wait Until Element Is Visible   //input[@id='user-name'][@value='standard_user']    # รอจนกว่าจะปรากฎ   --Visible ต่างกับ Page Contains ตรงที่ Visible จะรอจนกว่าเราจะเห็นแสดงที่หน้าเว็บ
    Wait Until Page Contains Element     //input[@id='user-name'][@value='standard_user']  #ใช้ในกรณีที่เราต้องการเช็คเพื่อให้แน่ใจว่า Element ที่เราต้องการจะใช้งานแสดงบนหน้าเพจแล้วหรือยัง เช่น หากเราจะกดปุ่ม Submit ก่อนจะกดเราก็มักจะใช้คำสั่ง Wait Until Page Contains Element

    #step 1.2: input password 
    Input Text    id= password    secret_sauce
   
    #step 1.2.1: Verify that input password has a value
    Textfield Value Should Be      id= password    secret_sauce

    Capture Page Screenshot     TC_01_{index}.png         #แคปจอบาง  หน้าปัจจุบันหน้าเดียว โดยตั้งชื่อรูป index คือ เลขรันรูป

    #step 1.3: Click Login
    Click Element   //input[@id="login-button"]

    #step 1.3.1: Verify that hamberger is show
    Wait Until Element Is Visible   //div[@id='header_container']//button[@id='react-burger-menu-btn']      #เหมือนใส่เงือนไขใน xpath เพื่อระบุแนะนอนว่าต้องเป็น ham menu ที่อยู่ header

    #step 1.3.2: Verify that "Swag Labs" is show
    Wait Until Element Is Visible   //div[@id='header_container']//div[@id='shopping_cart_container']   #เช็คว่าตะกร้าว่างมั้ย

    Capture Page Screenshot     TC_01_{index}.png
#step 2: Add product to cart
    #step 2.1 Add Sauce Labs Bike Light 1 ea
    #step 2.1.1 Verify Sauce Labs Bike Light Title
    Wait Until Element Is Visible   //div[@class='inventory_item']//div[text()='${product_sauce_labs_bike_light}[title]']

    #step 2.1.2 Verify Sauce Labs Bike Light Price
    Wait Until Element Is Visible   //div[@class='inventory_item' and .//div[text()='${product_sauce_labs_bike_light}[title]'] and .//div[@class='inventory_item_price'][text()='${product_sauce_labs_bike_light}[price]']]

    #step 2.1.3 Verify Sauce Labs Bike Light Add to cart
    Wait Until Element Is Visible   //div[@class='inventory_item' and .//div[text()='${product_sauce_labs_bike_light}[title]'] and .//div[@class='inventory_item_price'][text()='${product_sauce_labs_bike_light}[price]']]//button[text()='Add to cart']
    # xpath นี้ ใส่เงื่อนไข 3  โดยใช้ add. ใน xpath อย่างเพื่อระบุปุ่ม add to cart ที่ถูกต้องของสินค้านั้น อยู่ในclassบล็อก1บล็อก เลือกชื่อสินค้า ราคาสินค้า ถ้าเงื่อนไขตรงแล้วให้ใส่ button นอก [] ตามด้านบน


    #step 2.1.4 Get item in cart
    # condition if item >0 get text //span[@class='shopping_cart_badge']
    # condition if item ==0 Set 0
    ${has_count_of_cart}    Run Keyword And Return Status   Page Should Contain Element     //span[@class='shopping_cart_badge']
    IF  ${has_count_of_cart} == ${True}
    ${count_of_cart}    Get Text    //span[@class='shopping_cart_badge']
    ELSE
    ${count_of_cart}    Set Variable    0
    END


    #step 2.1.5 Click Add to cart
    Click Element       //div[@class='inventory_item' and .//div[text()='${product_sauce_labs_bike_light}[title]'] and .//div[@class='inventory_item_price'][text()='${product_sauce_labs_bike_light}[price]']]//button[text()='Add to cart']
    
    #step 2.1.6 Verify that cart plus one item
    #Should Be True      ${count_of_cart} + 1 == 1
    # page should contain Element       //span[@class='shopping_cart_badge']

    Wait Until Element Is Visible   //span[@class='shopping_cart_badge']
        ${last_count_of_cart}       Get Text       //span[@class='shopping_cart_badge']
    Should be True  ${count_of_cart} + 1 == ${last_count_of_cart}   

    Capture Page Screenshot     TC_01_{index}.png

    #step 2.2 Add Sauce Labs Bolt T-Shirt 1 ea
    #step 2.2.1 Verify Sauce Labs Bolt T-Shirt Title
     Wait Until Element Is Visible   //div[@class='inventory_item']//div[text()='${product_sauce_labs_bolt_t-Shirt}[title]']

    #step 2.2.2 Verify Sauce Labs Bolt T-Shirt Price
    Wait Until Element Is Visible   //div[@class='inventory_item' and .//div[text()='${product_sauce_labs_bolt_t-Shirt}[title]'] and .//div[@class='inventory_item_price'][text()='${product_sauce_labs_bolt_t-Shirt}[price]']]

    #step 2.2.3 Verify Sauce Labs Bolt T-Shirt Add to cart
    Wait Until Element Is Visible   //div[@class='inventory_item' and .//div[text()='${product_sauce_labs_bolt_t-Shirt}[title]'] and .//div[@class='inventory_item_price'][text()='${product_sauce_labs_bolt_t-Shirt}[price]']]//button[text()='Add to cart']

    #step 2.2.4 Get item in cart
     ${has_count_of_cart}    Run Keyword And Return Status   Page Should Contain Element     //span[@class='shopping_cart_badge']
    IF  ${has_count_of_cart} == ${True}
        ${count_of_cart}     Get Text  //span[@class='shopping_cart_badge']
    ELSE
        ${count_of_cart}    Set Variable    0
    END

    #step 2.2.5 Click Add to cart
    #Click Element       //div[@class='inventory_item' and .//div[text()='Sauce Labs Bolt T-Shirt'] and .//div[@class='inventory_item_price'][text()='15.99']]//button[text()='Add to cart']
    Click button       //div[@class='inventory_item' and .//div[text()='${product_sauce_labs_bolt_t-Shirt}[title]'] and .//div[@class='inventory_item_price'][text()='${product_sauce_labs_bolt_t-Shirt}[price]']]//button[text()='Add to cart']
   
    #step 2.2.6 Verify that cart plus one item
    Wait Until Element Is Visible   //span[@class='shopping_cart_badge']
        ${last_count_of_cart}       Get Text       //span[@class='shopping_cart_badge']
    Should be True  ${count_of_cart} + 1 == ${last_count_of_cart}   

    Capture Page Screenshot     TC_01_{index}.png


#step 3: Checkout
    #step 3.1 Click cart
    Click Element		//a[@class='shopping_cart_link']

    #step 3.2	Verify that "Your Cart" is show
    Wait Until Element Is Visible   //span[@class='title'][text()='Your Cart']
    

    #step 3.3 Verify Product same product list
    #step 3.3.1 Verify Sauce Labs Bike Light Title 
    Page Should Contain Element     //div[@class='cart_item' and .//div[@class='inventory_item_name'][text()='Sauce Labs Bike Light']]

    #step 3.3.2 Verify Sauce Labs Bike Light Price
    Page Should Contain Element     //div[@class='cart_item' and .//div[@class='inventory_item_name'][text()='Sauce Labs Bike Light'] and .//div[@class='inventory_item_price'][text()='9.99']]

    #step 3.3.3 Verify Sauce Labs Bike Light Remove
    Page Should Contain Element     //div[@class='cart_item' and .//div[@class='inventory_item_name'][text()='Sauce Labs Bike Light']]//button[text()='Remove']

    #step 3.3.4 QTY = 1
    Page Should Contain Element     //div[@class='cart_item' and .//div[@class='inventory_item_name'][text()='Sauce Labs Bike Light'] and .//div[@class='cart_quantity'][text()='1']]

    #step 3.4 Verify Product same product list
    #step 3.4.1 Verify Sauce Labs Bolt T-Shirt Title 
    Page Should Contain Element     //div[@class='cart_item' and .//div[@class='inventory_item_name'][text()='Sauce Labs Bolt T-Shirt']]

    #step 3.4.2 Verify Sauce Labs Bolt T-Shirt Price
    Page Should Contain Element     //div[@class='cart_item' and .//div[@class='inventory_item_name'][text()='Sauce Labs Bolt T-Shirt'] and .//div[@class='inventory_item_price'][text()='15.99']]

    #step 3.4.3 Verify Sauce Labs Bolt T-Shirt Remove
    Page Should Contain Element     //div[@class='cart_item' and .//div[@class='inventory_item_name'][text()='Sauce Labs Bolt T-Shirt']]//button[text()='Remove']

    #step 3.4.4 QTY = 1
    Page Should Contain Element     //div[@class='cart_item' and .//div[@class='inventory_item_name'][text()='Sauce Labs Bolt T-Shirt'] and .//div[@class='cart_quantity'][text()='1']]

    Capture Page Screenshot     TC_01_{index}.png

    #step 3.5 Click "Checkout" 
    #step 3.5.1 Click "Checkout" Button
    Click Element       //button[@id='checkout']

    #step 3.5.2 Verify that "Checkout: Your Information" is show
    #step 3.5.2.1 Verify that "Checkout: Your Information" is show
    Wait Until Element Is Visible       //span[@class='title'][text()='Checkout: Your Information']

    #step 3.5.2.2 Verify that Input First name is show
    Page Should Contain Element     //input[@id='first-name'] 

    #step 3.5.2.3 Verify that input Last name is show
    Page Should Contain Element     //input[@id='last-name'] 

    #step 3.5.2.4 Verify that Input Post code is show
    Page Should Contain Element     //input[@id='postal-code'] 


    Capture Page Screenshot     TC_01_{index}.png

    #step 4: Input Your Information
    #step 4.1: Input First name
    input Text          //input[@id='first-name']   Todsobb

	#step 4.1.1: Verify that input First name has value
    Textfield Value Should Be       //input[@id='first-name']   Todsobb

	#step 4.2: Input Last name
    input Text          //input[@id='last-name']   LastTodsob

	#step 4.2.1: Verify that input Last name has value
    Textfield Value Should Be   //input[@id='last-name']    LastTodsob

	#step 4.3.: Input Post code
    input Text         //input[@id='postal-code']    20220

	#step 4.3.1: Verify that input Post code has value
    Textfield Value Should Be   //input[@id='postal-code']   20220

	#step 4.4: Click Continue
    Click Element       //input[@id='continue']

	#step 4.4.1: Verify that "Checkout: Overview" is show
    #step 4.4.1.1: Verify that "Checkout: Overview" is show
    Wait Until Element Is Visible       //span[@class='title'][text()='Checkout: Overview']

    #step 4.4.1.2: Verify that "QTY" is show
    Wait Until Element Is Visible       //div[@class='cart_quantity_label'][text()='QTY']

    #step 4.4.1.3: Verify that "Description" is show
    Wait Until Element Is Visible       //div[@class='cart_desc_label'][text()='Description']

    #step 5: Verify that Summary same checkout page
    #step 5.1.1 Verify Sauce Labs Bike Light Title
    Page Should Contain Element     //div[@class='cart_item' and .//div[@class='inventory_item_name'][text()='Sauce Labs Bike Light']]

    #step 5.1.2 Verify Sauce Labs Bike Light Price
    Page Should Contain Element     //div[@class='cart_item' and .//div[@class='inventory_item_name'][text()='Sauce Labs Bike Light'] and .//div[@class='inventory_item_price'][text()='9.99']]

    #step 5.1.3 QTY = 1
    Page Should Contain Element     //div[@class='cart_item' and .//div[@class='inventory_item_name'][text()='Sauce Labs Bike Light'] and .//div[@class='cart_quantity'][text()='1']]

    #step 5.2.1 Verify Sauce Labs Bolt Title
     Page Should Contain Element     //div[@class='cart_item' and .//div[@class='inventory_item_name'][text()='Sauce Labs Bolt T-Shirt']]

    #step 5.2.2 Verify Verify Sauce Labs Bolt Price
    Page Should Contain Element     //div[@class='cart_item' and .//div[@class='inventory_item_name'][text()='Sauce Labs Bolt T-Shirt'] and .//div[@class='inventory_item_price'][text()='15.99']]

    #step 5.2.3 QTY = 1
    Page Should Contain Element     //div[@class='cart_item' and .//div[@class='inventory_item_name'][text()='Sauce Labs Bolt T-Shirt'] and .//div[@class='cart_quantity'][text()='1']]

    #step 5.3 Verify payment
    #step 5.3.1 Verify payment  label
    Page Should Contain Element     //div[@class='summary_info_label'][text()='Payment Information:']

    #step 5.3.2 Verify payment  value
    Page Should Contain Element     //div[@class='summary_value_label'][text()='SauceCard #31337']

    #step 5.4 Verify Shipping
    #step 5.4.1 Verify Shipping label
    Page Should Contain Element     //div[@class='summary_info_label'][text()='Shipping Information:']

    #step 5.4.2 Verify Shipping value
    Page Should Contain Element     //div[@class='summary_value_label'][text()='Free Pony Express Delivery!']

    #step 5.5 Price total
    #step 5.5.1 Verify that "Price total" is show
    Page Should Contain Element     //div[@class='summary_info_label'][text()='Price Total']
 
    #step 5.5.2 Verify that Item total =
    ${item_total}       Evaluate    ${product_sauce_labs_bike_light}[price] + ${product_sauce_labs_bolt_t-Shirt}[price]
    Page Should Contain Element     //div[@data-test='subtotal-label'][text()='Item total: $' and text()='${item_total}']

    #step 5.5.3 Verify that tax = ____
    ${tax_from_item_total}       Evaluate       ${item_total} * ${tax} /100
    ${tax_from_item_total_end}   Evaluate       round(${tax_from_item_total} + 0.005, 2)
    #log     ${tax_from_item_total}
    #log     ${tax_from_item_total_end} 
    Page Should Contain Element     //div[@data-test='tax-label'][text()='Tax: $' and text()='${tax_from_item_total_end}']

    #step 5.5.4 Verify that Total = ___
    ${last_total}               Evaluate    ${item_total} + ${tax_from_item_total_end}
    ${last_total_end}   Evaluate       round(${last_total}, 2)
     #$log     ${last_total_end}
    Page Should Contain Element     //div[@data-test='total-label'][text()='Total: $' and text()='${last_total_end}']

    #step 5.6: Click Finish
    Click Element       //button[@id='finish']

    #step 6: Verify Thank you
    #step 6.1: Verify that tile is show
    Wait Until Element Is Visible       //span[@class='title'][text()='Checkout: Complete!'] 

    #step 6.2: Verify that this page should show "Thank you"
    Page Should Contain Element         //h2[@class='complete-header'][text()='Thank you for your order!']

    #step 6.3: Verify that image is show
    Page Should Contain Element         //img[@class='pony_express']

        








    Capture Page Screenshot     TC_01_{index}.png







