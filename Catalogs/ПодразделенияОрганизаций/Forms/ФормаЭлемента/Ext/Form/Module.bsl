﻿
#Область УправлениеВнешнимВидом

&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		Элементы.Владелец.Доступность 		= Истина;		
	КонецЕсли;		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
			
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти
