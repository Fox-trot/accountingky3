﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЭлементов();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СчетУчетаЗатратПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	СвойстваСчета  = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Запись.СчетУчетаЗатрат);

	УчетПоНоменклатурнымГруппам = СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы
		ИЛИ СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы;
	
	Элементы.НоменклатурнаяГруппа.Видимость = УчетПоНоменклатурнымГруппам;
	
КонецПроцедуры

#КонецОбласти


