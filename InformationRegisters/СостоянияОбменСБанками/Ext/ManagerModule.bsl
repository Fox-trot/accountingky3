﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления.

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// для которых необходимо обновить записи в регистре.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СостоянияОбменСБанками.СсылкаНаОбъект КАК СсылкаНаОбъект
		|ИЗ
		|	РегистрСведений.СостоянияОбменСБанками КАК СостоянияОбменСБанками
		|ГДЕ
		|	СостоянияОбменСБанками.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОбменСБанками.УдалитьНаУтверждении)";
	
	МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("СсылкаНаОбъект");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

// Обновить записи регистра.
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбработкаЗавершена = Истина;
	
	Для Каждого ТипПрисоединенногоФайла Из Метаданные.ОпределяемыеТипы.ВладелецОбменСБанками.Тип.Типы() Цикл
		
		Если ТипПрисоединенногоФайла = Тип("ДокументСсылка.ПисьмоОбменСБанками") Тогда
			Продолжить;
		КонецЕсли;
		
		ПолноеИмяОбъектаМетаданных = Метаданные.НайтиПоТипу(ТипПрисоединенногоФайла).ПолноеИмя();
		
		Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъектаМетаданных);
		
		Если Выборка.Количество() > 0 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	Пока Выборка <> Неопределено И Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			МенеджерЗаписи = СоздатьМенеджерЗаписи();
			МенеджерЗаписи.СсылкаНаОбъект = Выборка.Ссылка;
			МенеджерЗаписи.Прочитать();
			МенеджерЗаписи.СсылкаНаОбъект = Выборка.Ссылка;
			МенеджерЗаписи.Состояние = Перечисления.СостоянияОбменСБанками.ТребуетсяОтправка;
			МенеджерЗаписи.Записать();
			
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			// Если не удалось обработать какой-либо документ, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать объект: %1 по причине:
				|%2'"),
				Выборка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Выборка.Ссылка.Метаданные(), Выборка.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Для Каждого ТипПрисоединенногоФайла Из Метаданные.ОпределяемыеТипы.ВладелецОбменСБанками.Тип.Типы() Цикл
		
		Если ТипПрисоединенногоФайла = Тип("ДокументСсылка.ПисьмоОбменСБанками") Тогда
			Продолжить;
		КонецЕсли;
		
		ПолноеИмяОбъектаМетаданных = Метаданные.НайтиПоТипу(ТипПрисоединенногоФайла).ПолноеИмя();
		
		Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъектаМетаданных) Тогда
			ОбработкаЗавершена = Ложь;
			Прервать;
		КонецЕсли;
	
	КонецЦикла;
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Процедуре РегистрыСведений.СостоянияОбменСБанками.ОбработатьДанныеДляПереходаНаНовуюВерсию не удалось обработать некоторые объекты (пропущены): %1'"), 
		ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
		Метаданные.НайтиПоПолномуИмени("ПолноеИмяОбъектаМетаданных"),,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Процедура РегистрыСведений.СостоянияОбменСБанками.ОбработатьДанныеДляПереходаНаНовуюВерсию обработала очередную порцию файлов: %1'"),
		ОбъектовОбработано));
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
