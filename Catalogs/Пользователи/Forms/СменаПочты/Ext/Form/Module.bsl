﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Пользователь = Параметры.Пользователь;
	ПарольПользователяСервиса = Параметры.ПарольПользователяСервиса;
	СтараяПочта = Параметры.СтараяПочта;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СменитьПочту(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = "";
	Если Не ЗначениеЗаполнено(СтараяПочта) Тогда
		ТекстВопроса =
			НСтр("ru = 'Адрес электронной почты пользователя сервиса изменен.
			           |Владельцы и администраторы абонента больше не смогут изменять параметры пользователя.'")
			+ Символы.ПС
			+ Символы.ПС;
	КонецЕсли;
	ТекстВопроса = ТекстВопроса + НСтр("ru = 'Выполнить изменение адреса электронной почты?'");
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("СменитьПочтуПродолжение", ЭтотОбъект),
		ТекстВопроса,
		РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьЗапросНаСменуПочты()
	
	ИнтеграцияСтандартныхПодсистем.ПриСозданииЗапросаНаСменуПочты(НоваяПочта,
		Пользователь, ПарольПользователяСервиса);
	
КонецПроцедуры

&НаКлиенте
Процедура СменитьПочтуПродолжение(Ответ, Контекст) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Попытка
			СоздатьЗапросНаСменуПочты();
		Исключение
			ПарольПользователяСервиса = "";
			ПодключитьОбработчикОжидания("ЗакрытьФорму", 0.1, Истина);
			ВызватьИсключение;
		КонецПопытки;
		
		ПоказатьПредупреждение(
			Новый ОписаниеОповещения("СменитьПочтуЗавершение", ЭтотОбъект, Контекст),
			НСтр("ru = 'На указанный адрес отправлено письмо с запросом на подтверждение.
			           |Почта будет изменена только после подтверждения запроса пользователем.'"));
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		СменитьПочтуЗавершение(Контекст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СменитьПочтуЗавершение(Контекст) Экспорт
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()
	
	Закрыть(ПарольПользователяСервиса);
	
КонецПроцедуры

#КонецОбласти
