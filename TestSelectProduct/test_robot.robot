*** Settings ***
Library	SeleniumLibrary
Suite Setup		Open Browser  https://www.saucedemo.com/ 	chrome	 options=add_experimental_option("detach", True) 

*** Variables *** 
${username}	standard_user 
${password}	secret_sauce
${FirstName}	Nutta
${LastName}		Pong
${ZipCode}		20008   
#@{EXPECTED_ITEMS}     Sauce Labs Bike Light		Sauce Labs Backpack
@{EXPECTED_ITEMS}    	Sauce Labs Onesie		Sauce Labs Backpack		 Sauce Labs Bike Light		

*** Test cases ***
TC-01-Login
	Login
	SelectProducts
	Check and buy
	
*** Keywords ***
Login
	sleep	0.5s
	Input text	id=user-name 		${username}
	sleep	0.5s
	Input text	id=password			${password}
	Click Button	//*[@type='submit']
SelectProducts
	sleep	1s
	Click Button	id=add-to-cart-sauce-labs-bike-light
	sleep	1s
	Click Button	id=add-to-cart-sauce-labs-backpack
	sleep	1s
	Click Button	id=add-to-cart-sauce-labs-onesie
	sleep	1s
	Click Element   xpath=//a[@class="shopping_cart_link"]
	Click Button	id=checkout
	sleep	0.5s
	Input text		id=first-name	${FirstName}
	sleep	0.5s
	Input text		id=last-name	${LastName}
	sleep	0.5s
	Input text		id=postal-code	${ZipCode}
	sleep	0.5s
	Click Button	id=continue
Check and buy
    Wait Until Element Is Visible   css=.inventory_item_name    timeout=10
    ${product_names}    Execute JavaScript    return Array.from(document.querySelectorAll('.inventory_item_name')).map(element => element.textContent)
    #${expected_product_names}=    Create List    Sauce Labs Bike Light    Sauce Labs Backpack  #จะประกาศสร้าง List แบบนี้ก็ได้ พิมแล้วกด Tab หรือจะประกาศที่ Variables แล้วเรียกใช้ก็ได้
    FOR    ${expected_name}    IN    @{EXPECTED_ITEMS} 
       # Run Keyword If    '${expected_name}' in '${product_names}'    Log    '${expected_name}' exists in product names	#แบบผิด
		Run Keyword If    "'${expected_name}'" in "${product_names}"    Log    '${expected_name}' exists in product names	#แบบถูกถ้าจะให้เช็คทั้งสองควรถูกครอบด้วยเครื่องหมายคำพูด (quote) ทั้งสองด้าน เพื่อให้เป็นสตริงที่ถูกต้องที่จะใช้ในการเปรียบเทียบ
        ...    ELSE    Fail    '${expected_name}' does not exist in product names
    END
 	Click Button	name=finish



***comment
ในการใช้ลูปเพื่อตรวจสอบชื่อสินค้าที่คาดหวัง (EXPECTED_ITEMS) กับรายการสินค้าที่ได้รับจากหน้าเว็บ (product_names) 
ให้แน่ใจว่า EXPECTED_ITEMS ได้รับค่าเป็นลิสต์หรือไม่ และต้องใช้ FOR IN ให้ถูกต้องโดยการใช้ @{} สำหรับการอ้างอิงที่ถูกต้อง
นอกจากนี้ ตรวจสอบว่าคำสั่ง Run Keyword If ถูกต้องหรือไม่ โดยการใส่เครื่องหมาย quote รอบตัวแปร expected_name และ product_names 
ในเงื่อนไข เพื่อให้ Python รับรู้ว่าเป็นสตริงที่ถูกต้องที่ใช้ในการเปรียบเทียบได้

คำสั่ง Run Keyword If ในโค้ดของคุณใช้สำหรับการตรวจสอบว่าค่าของตัวแปร ${expected_name} มีอยู่ในตัวแปร ${product_names} หรือไม่ 
หากมีอยู่ โค้ดจะทำการแสดงข้อความที่บอกว่า '${expected_name}' มีอยู่ในรายการชื่อสินค้า ${product_names}
ดังนั้นเมื่อค่าของ ${expected_name} ตรงกับค่าใดค่าหนึ่งใน ${product_names} โค้ดจะทำงาน 
และทำการแสดงข้อความ "${expected_name} exists in product names" ในการทำงานจริงๆ นอกจากนี้ ถ้า ${expected_name} 
ไม่มีอยู่ใน ${product_names} โค้ดจะไม่ทำงาน และไม่มีข้อความถูกแสดงผล


	-------------
	Select From List By Label	name=com		Doppio  
	sleep		2s

	# สรุป locator
	# แบบname ใช้  name = ชื่อname ของ tag input ที่ต้องการ เช่น name=user
	# แบบ id ใช้   id = ชื่อid ของ tag input ที่ต้องการ  เช่น  id = password-box

	# แบบ xpath 
	# 01 = xpath=//input[@v='username'] 
	# 02 = xpath=//input[@v='username']/input
	# 03 = xpath=//div[contains(@v,'username')]/input
	# 04 = xpath=//div[span[@c='Username']]/input
	# 05 = xpath=//div[span[text()='User:']]/input
	# 06 = xpath=//div[@k='abc'and @p='xyz']/input
	