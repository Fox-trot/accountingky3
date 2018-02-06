﻿
#Область ПроцедурыИФункцииОбщегоНазначения

// Процедура устанавливает видимость и доступность элементов.
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Если Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаУдержаний.Процентом") Тогда 
		Элементы.СтраницаБазовыеВидыРасчета.Видимость = Истина;
	ИначеЕсли Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаУдержаний.ФиксированнойСуммой") Тогда 
		Элементы.СтраницаБазовыеВидыРасчета.Видимость = Ложь;
	КонецЕсли;	                                             
	
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода СпособРасчета.
//
&НаКлиенте
Процедура СпособРасчетаПриИзменении(Элемент)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти
