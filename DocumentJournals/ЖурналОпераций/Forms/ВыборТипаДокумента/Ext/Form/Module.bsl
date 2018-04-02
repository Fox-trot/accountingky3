﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоВводНаОсновании = ЗначениеЗаполнено(Параметры.Основание);
	
	Если ЭтоВводНаОсновании Тогда
		
		МетаданныеОснование = Параметры.Основание.Метаданные();
		Для Каждого ОбъектМетаданных Из Метаданные.Документы Цикл
			
			Если ОбъектМетаданных.ВводитсяНаОсновании.Содержит(МетаданныеОснование) 
				И ПравоДоступа("Изменение", ОбъектМетаданных)
			   	И ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОбъектМетаданных) Тогда
				ТипыДокументов.Добавить(ОбъектМетаданных.Имя, ОбъектМетаданных.Синоним);
			КонецЕсли;
			
		КонецЦикла;		
	Иначе
		
		ДокументыЖурнала = ЖурналыДокументов.ЖурналОпераций.СоставДокументов();
		Для Каждого ОбъектМетаданных Из ДокументыЖурнала Цикл
			Если ПравоДоступа("Изменение", ОбъектМетаданных) Тогда
				ТипыДокументов.Добавить(ОбъектМетаданных.Имя, ОбъектМетаданных.Синоним);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТипыДокументов.Количество() = 0 Тогда
		Если ЭтоВводНаОсновании Тогда
			ВызватьИсключение НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'");
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Нарушение прав доступа!'"), , , , Отказ);
		КонецЕсли; 
		Возврат;
	КонецЕсли;
	
	ТипыДокументов.СортироватьПоПредставлению();
	
	// Установка текущей строки списка
	Если ЗначениеЗаполнено(Параметры.НачальноеЗначение) Тогда
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Параметры.НачальноеЗначение);
		Если ОбъектМетаданных <> Неопределено Тогда
			ТекущаяСтрока = ТипыДокументов.НайтиПоЗначению(ОбъектМетаданных.Имя);
			Если ТекущаяСтрока <> Неопределено Тогда
				Элементы.ТипыДокументов.ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТипыДокументов

&НаКлиенте
Процедура ТипыДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТипыДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОповеститьОВыборе(ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ТекущиеДанные = Элементы.ТипыДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОповеститьОВыборе(ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
