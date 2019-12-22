﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ТекущаяНастройкаОбмена;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для каждого ЭлементКоллекции Из Параметры.МассивНастроекОбмена Цикл
		
		НовСтрока = НастройкиОбмена.Добавить();
		НовСтрока.НастройкаОбмена = ЭлементКоллекции;
		ДатаПоследнейСинхронизации = ОбменСБанкамиСлужебный.ДатаПоследнейСинхронизации(ЭлементКоллекции);
		НовСтрока.ДатаПоследнейСинхронизации = ОбменДаннымиСервер.ОтносительнаяДатаСинхронизации(ДатаПоследнейСинхронизации);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Настройки.Удалить("НастройкиОбмена");
	Если ЗапомнитьВыбор Тогда
		МассивВыбранныхНастроек = Новый Массив;
		Для каждого ЭлементКоллекции Из НастройкиОбмена Цикл
			Если ЭлементКоллекции.Выбран Тогда
				МассивВыбранныхНастроек.Добавить(ЭлементКоллекции.НастройкаОбмена);
			КонецЕсли;
		КонецЦикла;
	
		Настройки.Вставить("МассивВыбранныхНастроек", МассивВыбранныхНастроек);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	МассивВыбранныхНастроек = Настройки.Получить("МассивВыбранныхНастроек");
	
	Если МассивВыбранныхНастроек <> Неопределено Тогда
		Для каждого ЭлементКоллекции Из НастройкиОбмена Цикл
			Если МассивВыбранныхНастроек.Найти(ЭлементКоллекции.НастройкаОбмена) <> Неопределено Тогда
				ЭлементКоллекции.Выбран = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиОбмена

&НаКлиенте
Процедура НастройкиОбменаВыбранПриИзменении(Элемент)
	
	СохраняемыеВНастройкахДанныеМодифицированы = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьСинхронизацию(Команда)
	
	ОчиститьСообщения();
	Для каждого ЭлементКоллекции Из НастройкиОбмена Цикл
		ЭлементКоллекции.Выполнено = Ложь;
		ЭлементКоллекции.Картинка = Новый Картинка;
	КонецЦикла;

	Синхронизация()
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьФлажки(Команда)
	
	Для каждого ЭлементКоллекции Из НастройкиОбмена Цикл
		ЭлементКоллекции.Выбран = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для каждого ЭлементКоллекции Из НастройкиОбмена Цикл
		ЭлементКоллекции.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Инвертировать(Команда)
	
	Для каждого ЭлементКоллекции Из НастройкиОбмена Цикл
		ЭлементКоллекции.Выбран = НЕ ЭлементКоллекции.Выбран;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Синхронизация()
	
	Для каждого ЭлементКоллекции Из НастройкиОбмена Цикл
		Если ЭлементКоллекции.Выбран И Не ЭлементКоллекции.Выполнено Тогда
			ЭлементКоллекции.Выполнено = Истина;
			ЭлементКоллекции.Картинка = БиблиотекаКартинок.ДлительнаяОперация16;
			ТекущаяНастройкаОбмена = ЭлементКоллекции.НастройкаОбмена;
			Оповещение = Новый ОписаниеОповещения("ПослеСинхронизации", ЭтотОбъект);
			ОбменСБанкамиСлужебныйКлиент.СинхронизироватьСБанком(Оповещение, ТекущаяНастройкаОбмена, Ложь);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСинхронизации(Результат, ДополнительныеПараметры) Экспорт
	
	Для каждого ЭлементКоллекции Из НастройкиОбмена Цикл
		Если ЭлементКоллекции.НастройкаОбмена = ТекущаяНастройкаОбмена Тогда
			ЭлементКоллекции.ДатаПоследнейСинхронизации = ОтносительнаяДатаСинхронизации(ЭлементКоллекции.НастройкаОбмена);
			Если Результат Тогда
				ЭлементКоллекции.Картинка = БиблиотекаКартинок.Успешно;
			Иначе
				ЭлементКоллекции.Картинка = БиблиотекаКартинок.СостояниеОбменаДаннымиОшибка;
			КонецЕсли;
			
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПодключитьОбработчикОжидания("Синхронизация", 0.1, Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОтносительнаяДатаСинхронизации(Знач НастройкаОбмена)
	
	ДатаПоследнейСинхронизации = ОбменСБанкамиСлужебный.ДатаПоследнейСинхронизации(НастройкаОбмена);
	Возврат ОбменДаннымиСервер.ОтносительнаяДатаСинхронизации(ДатаПоследнейСинхронизации);
	
КонецФункции

&НаКлиенте
Процедура НастройкиОбменаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущийЭлемент = Элементы.НастройкиОбменаНастройкаОбмена Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение( , Элемент.ТекущиеДанные.НастройкаОбмена);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти