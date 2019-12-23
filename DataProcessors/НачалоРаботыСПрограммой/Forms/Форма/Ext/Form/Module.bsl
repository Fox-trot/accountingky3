﻿
#Область ОбработчикиФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КэшЗначений = Новый Структура;
	КэшЗначений.Вставить("Пользователь", Пользователи.АвторизованныйПользователь());
	КэшЗначений.Вставить("РазрешитьЗакрытие", Ложь);
	КэшЗначений.Вставить("ДополнительныйПараметр", НачалоРаботыСПрограммойСервер.ЗначениеДополнительногоПараметра());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитов

&НаКлиенте
Процедура ПарольПодтверждениеПриИзменении(Элемент)
	
	Если ПользовательПароль <> ПользовательПарольПодтверждение Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru ='Не совпадают пароли'"), , "ПользовательПарольПодтверждение");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура НачатьРаботуСПрограммой(Команда)
	Перем Ошибки;
	
	ДополнительныйПараметр = "";
	Если ВРЕГ(ПользовательИмя) = КэшЗначений.ДополнительныйПараметр Тогда
		
		ДополнительныйПараметр = КэшЗначений.ДополнительныйПараметр;
		КэшЗначений.РазрешитьЗакрытие = Истина;
		
	Иначе
		
		Если ПользовательПароль <> ПользовательПарольПодтверждение Тогда	
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ПользовательПароль", НСтр("ru ='Не совпадают пароли'"), "");	
		КонецЕсли;
		
		Если ПустаяСтрока(ПользовательИмя) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ПользовательИмя", НСтр("ru ='Заполните имя пользователя'"), "");
		КонецЕсли;
		
		КэшЗначений.РазрешитьЗакрытие = (Ошибки = Неопределено);
		
		Если НЕ КэшЗначений.РазрешитьЗакрытие Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
			Возврат;
			
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("НачатьРаботу", 					Истина);	
	ПараметрыЗакрытия.Вставить("Пользователь",					КэшЗначений.Пользователь);
	ПараметрыЗакрытия.Вставить("ПользовательИмя",				ПользовательИмя);
	ПараметрыЗакрытия.Вставить("ПользовательПароль",			ПользовательПароль);	
	ПараметрыЗакрытия.Вставить("ДополнительныйПараметр",		ДополнительныйПараметр);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

#КонецОбласти
