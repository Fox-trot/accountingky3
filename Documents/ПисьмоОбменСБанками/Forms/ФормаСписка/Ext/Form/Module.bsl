﻿#Область ОписаниеПеременных

&НаКлиенте
Перем РезультатЗаданияРасчетаКоличестваПоРазделам;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();

	ЗаполнитьСпискиОрганизацийИБанков(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализироватьДерево();
	
	СформироватьТаблицуБыстрогоОтбора();

	Элементы.СброситьОтбор.Доступность = Ложь;
	
	СоздатьОтборПоРазделамВСпискахРазделов();
	
	АдресРезультата = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	ОбменСБанкамиСлужебный.РассчитатьКоличествоПисемПоРазделам(Неопределено, АдресРезультата);
	
	СтруктураВозврата = ПолучитьИзВременногоХранилища(АдресРезультата);
		
	ДеревоНавигации = РеквизитФормыВЗначение("ДеревоДействий");

	Для каждого ЭлементКоллекции Из СтруктураВозврата Цикл
		СтрокаНавигации = ДеревоНавигации.Строки.Найти(ЭлементКоллекции.Ключ, "Значение", Истина);
		СтрокаНавигации.Представление = СтрокаНавигации.ШаблонПредставления;
		СтрокаНавигации.Количество = ЭлементКоллекции.Значение;
		Если ЭлементКоллекции.Значение > 0 Тогда
			СтрокаНавигации.Представление = СтрокаНавигации.ШаблонПредставления + " (" + СтрокаНавигации.Количество + ")";
		КонецЕсли;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоНавигации, "ДеревоДействий");
	
	ПоказатьБыстрыйПоиск = Истина;
	
	// СтандартныеПодсистемы.Печать
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаОсновная;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.Печать
	
	// Обход ошибки проверки конфигурации
	Если Ложь Тогда
		Подключаемый_ВыполнитьКомандуНаСервере(Неопределено, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьДоступностьСбросаОтбора(ЭтотОбъект, БыстрыеОтборы)
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеОбменСБанками" Тогда
		Элементы.Письма.Обновить();
		Если Не ЗаданиеВыполняется Тогда
			РезультатЗаданияРасчетаКоличестваПоРазделам = ЗапускЗаданияОбновленияКоличестваПоРазделам(УникальныйИдентификатор);
			ПодключитьОбработчикОжидания("ОбновитьКоличествоВРазделах", 0.1, Истина);
		КонецЕсли;
	КонецЕсли;
	
	// Обход ошибки проверки конфигурации
	Если Ложь Тогда
		Подключаемый_ВыполнитьКоманду(Неопределено);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыБыстрыеОтборы

&НаКлиенте
Процедура БыстрыеОтборыЗначениеПриИзменении(Элемент)
	
	УстановитьДоступностьСбросаОтбора(ЭтотОбъект, БыстрыеОтборы);
	
	ПриИзмененииОтбораНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыеОтборыЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Элементы.БыстрыеОтборы.ТекущиеДанные.Параметр = "Организация"
		ИЛИ Элементы.БыстрыеОтборы.ТекущиеДанные.Параметр = "Банк" Тогда
		ДанныеВыбора = Элементы.БыстрыеОтборы.ТекущиеДанные.СписокВыбора;
		СтандартнаяОбработка = Ложь;
	ИначеЕсли Элементы.БыстрыеОтборы.ТекущиеДанные.Параметр = "Основание" Тогда
		СтандартнаяОбработка = Ложь;
		Оповещение = Новый ОписаниеОповещения("ПослеВыбораТипаОснования", ЭтотОбъект);
		ЗаголовокВыбора = НСтр("ru = 'Выберите тип основания письма'");
		Элементы.БыстрыеОтборы.ТекущиеДанные.СписокВыбора.ПоказатьВыборЭлемента(Оповещение, ЗаголовокВыбора);
	ИначеЕсли Элементы.БыстрыеОтборы.ТекущиеДанные.Параметр = "СчетОрганизации" Тогда
		СтандартнаяОбработка = Ложь;
		Отбор = Новый Структура;
	
		Если ЗначениеЗаполнено(Организация) Тогда
			Отбор.Вставить("Организация", Организация);
			Отбор.Вставить("Владелец", Организация);
		Иначе
			ПараметрыОтбора = Новый Структура("Параметр", "Организация");
			МассивСтрокКоллекции = БыстрыеОтборы.НайтиСтроки(ПараметрыОтбора);
			НайденнаяСтрока = МассивСтрокКоллекции.Получить(0);
			Отбор.Вставить("СписокОрганизаций", НайденнаяСтрока.СписокВыбора.ВыгрузитьЗначения());
		КонецЕсли;
	
		Если ЗначениеЗаполнено(Банк) Тогда
			Отбор.Вставить("Банк", Банк);
		Иначе
			ПараметрыОтбора = Новый Структура("Параметр", "Банк");
			МассивСтрокКоллекции = БыстрыеОтборы.НайтиСтроки(ПараметрыОтбора);
			НайденнаяСтрока = МассивСтрокКоллекции.Получить(0);
			Отбор.Вставить("СписокБанков", НайденнаяСтрока.СписокВыбора.ВыгрузитьЗначения());
		КонецЕсли;
	
		НазваниеСчетаВМетаданных = НазваниеСчетаВМетаданных();
		ПараметрыФормы = Новый Структура("Отбор", Отбор);
		ОткрытьФорму(
			"Справочник." + НазваниеСчетаВМетаданных + ".ФормаВыбора", ПараметрыФормы, Элементы.БыстрыеОтборыЗначение);
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыеОтборыЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		Если Элементы.БыстрыеОтборы.ТекущиеДанные.Параметр = "Основание" Тогда
			СтандартнаяОбработка = Ложь;
			ПараметрыОтбора = Новый Структура("Параметр", "Основание");
			МассивСтрокКоллекции = БыстрыеОтборы.НайтиСтроки(ПараметрыОтбора);
			НайденнаяСтрока = МассивСтрокКоллекции.Получить(0);
			НайденнаяСтрока.Значение = ВыбранноеЗначение;
			
			Основание = ВыбранноеЗначение;
			
			РеквизитыОбъекта = ОбменСБанкамиСлужебныйВызовСервера.РеквизитыОснованияПисьма(ВыбранноеЗначение);
			СчетОрганизации = РеквизитыОбъекта.Счет;
			РеквизитОрганизация = РеквизитыОбъекта.Организация;
			РеквизитБанк = РеквизитыОбъекта.Банк;
			
			Для каждого ЭлементКоллекции Из БыстрыеОтборы Цикл
				
				Если ЭлементКоллекции.Параметр = "СчетОрганизации" Тогда
					ЭлементКоллекции.Значение = СчетОрганизации;
					ЭлементКоллекции.Недоступен = Истина;
				ИначеЕсли ЭлементКоллекции.Параметр = "Организация" Тогда
					ЭлементКоллекции.Значение = РеквизитОрганизация;
					ЭлементКоллекции.Недоступен = Истина;
				ИначеЕсли ЭлементКоллекции.Параметр = "Банк" Тогда
					ЭлементКоллекции.Значение = РеквизитБанк;
					ЭлементКоллекции.Недоступен = Истина;
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			Элементы.БыстрыеОтборы.ЗакончитьРедактированиеСтроки(Ложь);
			
		ИначеЕсли Элементы.БыстрыеОтборы.ТекущиеДанные.Параметр = "СчетОрганизации" Тогда
			СтандартнаяОбработка = Ложь;
			ПараметрыОтбора = Новый Структура("Параметр", "СчетОрганизации");
			МассивСтрокКоллекции = БыстрыеОтборы.НайтиСтроки(ПараметрыОтбора);
			НайденнаяСтрока = МассивСтрокКоллекции.Получить(0);
			НайденнаяСтрока.Значение = ВыбранноеЗначение;
			
			СчетОрганизации = ВыбранноеЗначение;
			
			РеквизитыСчета = ОбменСБанкамиСлужебныйВызовСервера.РеквизитыБанковскогоСчетаОрганизации(ВыбранноеЗначение);
			РеквизитОрганизация = РеквизитыСчета.Организация;
			РеквизитБанк = РеквизитыСчета.Банк;
			Для каждого ЭлементКоллекции Из БыстрыеОтборы Цикл
				Если ЭлементКоллекции.Параметр = "Организация" Тогда
					ЭлементКоллекции.Значение = РеквизитОрганизация;
					ЭлементКоллекции.Недоступен = Истина;
				ИначеЕсли ЭлементКоллекции.Параметр = "Банк" Тогда
					ЭлементКоллекции.Значение = РеквизитБанк;
					ЭлементКоллекции.Недоступен = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		УстановитьДоступностьСбросаОтбора(ЭтотОбъект, БыстрыеОтборы);
		ПриИзмененииОтбораНаСервере();

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыеОтборыЗначениеОчистка(Элемент, СтандартнаяОбработка)
	
	Строка = Элементы.БыстрыеОтборы.ТекущиеДанные;
	ЗаполненСчет = Ложь;
	Если Строка.Параметр = "Основание" Тогда
		
		Для каждого ЭлементКоллекции Из БыстрыеОтборы Цикл
			Если ЭлементКоллекции.Параметр = "СчетОрганизации" Тогда
				ЭлементКоллекции.Недоступен = Ложь;
				ЗаполненСчет = ЗначениеЗаполнено(ЭлементКоллекции.Значение);
			ИначеЕсли ЭлементКоллекции.Параметр = "Организация" Тогда
				ЭлементКоллекции.Недоступен = ЗаполненСчет;
			ИначеЕсли ЭлементКоллекции.Параметр = "Банк" Тогда
				ЭлементКоллекции.Недоступен = ЗаполненСчет;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли Строка.Параметр = "СчетОрганизации" Тогда
		
		Для каждого ЭлементКоллекции Из БыстрыеОтборы Цикл
			Если ЭлементКоллекции.Параметр = "Организация" Тогда
				ЭлементКоллекции.Недоступен = Ложь;
			ИначеЕсли ЭлементКоллекции.Параметр = "Банк" Тогда
				ЭлементКоллекции.Недоступен = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоДействий

&НаКлиенте
Процедура ДеревоДействийПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НовыйРаздел = Элемент.ТекущиеДанные.Значение;
	Если НовыйРаздел <> ТекущийРаздел Тогда
		ПриИзмененииРаздела(НовыйРаздел);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НовоеПисьмо(Команда)
	
	ОткрытьФорму("Документ.ПисьмоОбменСБанками.Форма.ПисьмоВБанк");
	
КонецПроцедуры

&НаКлиенте
Процедура Ответить(Команда)
	
	ОчиститьСообщения();
	
	Если ЗначениеЗаполнено(Элементы.Письма.ТекущаяСтрока) Тогда
		ПараметрыФормы = Новый Структура("ЗначениеЗаполнения", Элементы.Письма.ТекущаяСтрока);
		ОткрытьФорму("Документ.ПисьмоОбменСБанками.Форма.ПисьмоВБанк", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПолучить(Команда)
		
	ОчиститьСообщения();
	
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(Банк) Тогда
		ОбменСБанкамиКлиент.СинхронизироватьСБанком(Организация, Банк);
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("Параметр", "Банк");
	МассивСтрокКоллекции = БыстрыеОтборы.НайтиСтроки(ПараметрыОтбора);
	Если МассивСтрокКоллекции.Количество() Тогда
		НайденнаяСтрока = МассивСтрокКоллекции.Получить(0);
		БанкОтбор = НайденнаяСтрока.Значение;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("Параметр", "Организация");
	МассивСтрокКоллекции = БыстрыеОтборы.НайтиСтроки(ПараметрыОтбора);
	Если МассивСтрокКоллекции.Количество() Тогда
		НайденнаяСтрока = МассивСтрокКоллекции.Получить(0);
		ОрганизацияОтбор = НайденнаяСтрока.Значение;
	КонецЕсли;
	
	БанкСинхронизация = ?(ЗначениеЗаполнено(Банк), Банк, БанкОтбор);
	ОрганизацияСинхронизация = ?(ЗначениеЗаполнено(Организация), Организация, ОрганизацияОтбор);
	ОбменСБанкамиКлиент.СинхронизироватьСБанком(ОрганизацияСинхронизация, БанкСинхронизация);
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьОтбор(Команда)
	
	Для Каждого Строка Из БыстрыеОтборы Цикл
		Если Строка.Параметр = "Основание" ИЛИ Строка.Параметр = "СчетОрганизации" ИЛИ Строка.Параметр = "Организация"
			ИЛИ Строка.Параметр = "Банк" Тогда
			Строка.Значение = Неопределено;
		Иначе
			Строка.Значение = "";
		КонецЕсли;
		Строка.Недоступен = Ложь;
	КонецЦикла;

	Элементы.СброситьОтбор.Доступность = Ложь;
	ПриИзмененииОтбораНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОчиститьСообщения();
	
	Элементы.Письма.Обновить();
	Если Не ЗаданиеВыполняется Тогда
		РезультатЗаданияРасчетаКоличестваПоРазделам = ЗапускЗаданияОбновленияКоличестваПоРазделам(УникальныйИдентификатор);
		ПодключитьОбработчикОжидания("ОбновитьКоличествоВРазделах", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Письма);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Письма, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Письма);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗапускЗаданияОбновленияКоличестваПоРазделам(Знач УникальныйИдентификатор)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Расчет количества писем по разделам'");

	ПараметрыПроцедуры = Новый Структура;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"ОбменСБанкамиСлужебный.РассчитатьКоличествоПисемПоРазделам", ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьКоличествоВРазделах()
	
	Если РезультатЗаданияРасчетаКоличестваПоРазделам.Статус = "Выполняется" Тогда
		ЗаданиеВыполняется = Истина;
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		Оповещение = Новый ОписаниеОповещения("ПослеПолученияКоличестваПоРазделам", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(
			РезультатЗаданияРасчетаКоличестваПоРазделам, Оповещение, ПараметрыОжидания);
	ИначеЕсли РезультатЗаданияРасчетаКоличестваПоРазделам.Статус = "Выполнено" Тогда
		ПослеПолученияКоличестваПоРазделам(РезультатЗаданияРасчетаКоличестваПоРазделам);
	Иначе
		ЗаданиеВыполняется = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияКоличестваПоРазделам(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗаданиеВыполняется = Ложь;
	
	Если Результат = Неопределено ИЛИ Результат.Статус = "Ошибка" Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВозврата = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	ЭлементыПервогоУровня = ДеревоДействий.ПолучитьЭлементы();
	Для каждого ПервыйУровень Из ЭлементыПервогоУровня Цикл
		ЭлементыВторогоУровня = ПервыйУровень.ПолучитьЭлементы();
		Для каждого ВторойУровень Из ЭлементыВторогоУровня Цикл
			Если СтруктураВозврата.Свойство(ВторойУровень.Значение, ВторойУровень.Количество) Тогда
				Если ВторойУровень.Количество Тогда
					ПредставлениеКоличества = ?(ВторойУровень.Количество = 1000, "999+", ВторойУровень.Количество);
					ВторойУровень.Представление = ВторойУровень.ШаблонПредставления + " (" + ПредставлениеКоличества + ")";
				Иначе
					ВторойУровень.Представление = ВторойУровень.ШаблонПредставления;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииОтбораНаСервере()
	
	Отбор = Письма.Отбор;
	
	ГруппаБыстрыйОтбор = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		Отбор.Элементы, "БыстрыйОтбор", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
		
	Режим = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ГруппаБыстрыйОтбор.РежимОтображения = Режим;
		
	Для каждого СтрокаОтбора Из БыстрыеОтборы Цикл
			
		Поле = СтрокаОтбора.Параметр;
		Значение = СтрокаОтбора.Значение;
	
		Если Не ПолеДоступноДляОтбора(Отбор, Поле) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Поле = "Основание" ИЛИ Поле = "Организация" ИЛИ Поле = "Банк" ИЛИ Поле = "СчетОрганизации" Тогда
			
			Использование = ЗначениеЗаполнено(Значение);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
				ГруппаБыстрыйОтбор, Поле, ВидСравненияКомпоновкиДанных.Равно, Значение, , Использование, Режим);
				
		ИначеЕсли Поле = "Тема" ИЛИ Поле = "Текст" Тогда
			
			Использование = ЗначениеЗаполнено(Значение);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
				ГруппаБыстрыйОтбор, Поле, ВидСравненияКомпоновкиДанных.Подобно, "%" + Значение + "%", , Использование, Режим);
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Функция ПолеДоступноДляОтбора(Знач Отбор, Знач Поле) 
	
	Если Поле = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Поле) = Тип("Строка") Тогда
		Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЕсли;
	
	ДоступноеПоле = Отбор.ДоступныеПоляОтбора.НайтиПоле(Поле);
	
	Возврат (ДоступноеПоле <> Неопределено);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьСбросаОтбора(Форма, БыстрыеОтборы)

	ЕстьОтборы = Ложь;
	Для Каждого Строка Из БыстрыеОтборы Цикл
		Если ЗначениеЗаполнено(Строка.Значение) Тогда
			ЕстьОтборы = Истина;
			Прервать;
		КонецЕсли
	КонецЦикла;
	
	Форма.Элементы.СброситьОтбор.Доступность = ЕстьОтборы;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НазваниеСчетаВМетаданных()
	
	ОписаниеТипаБанковскийСчет = Метаданные.ОпределяемыеТипы.СчетОрганизацииОбменСБанками.Тип;
	ТипСчет = ОписаниеТипаБанковскийСчет.Типы().Получить(0);
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипСчет);
	Возврат ОбъектМетаданных.Имя;
	
КонецФункции

&НаКлиенте
Процедура ПослеВыбораТипаОснования(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НазваниеДокументаВМетаданных = ОбменСБанкамиСлужебныйВызовСервера.НазваниеОбъектаВМетаданных(
		ВыбранныйЭлемент.Значение);
	ПараметрыФормы = Новый Структура;
	Отбор = Новый Структура;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
	Иначе
		ПараметрыОтбора = Новый Структура("Параметр", "Организация");
		МассивСтрокКоллекции = БыстрыеОтборы.НайтиСтроки(ПараметрыОтбора);
		НайденнаяСтрока = МассивСтрокКоллекции.Получить(0);
		Отбор.Вставить("СписокОрганизаций", НайденнаяСтрока.СписокВыбора.ВыгрузитьЗначения());
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Банк) Тогда
		Отбор.Вставить("Банк", Банк);
	Иначе
		ПараметрыОтбора = Новый Структура("Параметр", "Банк");
		МассивСтрокКоллекции = БыстрыеОтборы.НайтиСтроки(ПараметрыОтбора);
		НайденнаяСтрока = МассивСтрокКоллекции.Получить(0);
		Отбор.Вставить("СписокБанков", НайденнаяСтрока.СписокВыбора.ВыгрузитьЗначения());
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СчетОрганизации) Тогда
		Отбор.Вставить("СчетОрганизации", СчетОрганизации);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Отбор", Отбор);
	
	ОткрытьФорму(
		"Документ." + НазваниеДокументаВМетаданных + ".ФормаВыбора", ПараметрыФормы, Элементы.БыстрыеОтборыЗначение);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиОрганизацийИБанков(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	НастройкиОбменСБанкамиИсходящиеДокументы.Ссылка.Организация КАК Организация,
	|	НастройкиОбменСБанкамиИсходящиеДокументы.Ссылка.Банк КАК Банк
	|ИЗ
	|	Справочник.НастройкиОбменСБанками.ИсходящиеДокументы КАК НастройкиОбменСБанкамиИсходящиеДокументы
	|ГДЕ
	|	НастройкиОбменСБанкамиИсходящиеДокументы.ИсходящийДокумент = ЗНАЧЕНИЕ(Перечисление.ВидыЭДОбменСБанками.Письмо)
	|	И НЕ НастройкиОбменСБанкамиИсходящиеДокументы.Ссылка.Недействительна
	|	И НЕ НастройкиОбменСБанкамиИсходящиеДокументы.Ссылка.ПометкаУдаления";
	
	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	
	Если НЕ ТаблицаРезультата.Количество() Тогда
		ТекстОшибки = НСтр("ru = 'Не найдено ни одной настройки обмена 1С:ДиректБанк c поддержкой отправки писем.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , , , Отказ);
		Возврат;
	КонецЕсли;
	
	ТаблицаНастроек = ПоместитьВоВременноеХранилище(ТаблицаРезультата);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьДерево()

	Дерево = РеквизитФормыВЗначение("ДеревоДействий");
	
	СтрокаВходящие = Дерево.Строки.Добавить();
	СтрокаВходящие.Значение = "Входящие";
	СтрокаВходящие.Представление = НСтр("ru = 'Входящие'");
	СтрокаВходящие.ШаблонПредставления = НСтр("ru = 'Входящие'");
	
	НовЗапись = СтрокаВходящие.Строки.Добавить();
	НовЗапись.Значение = "ВходящиеНепрочитанные";
	НовЗапись.Представление = НСтр("ru = 'Непрочитанные'");
	НовЗапись.ШаблонПредставления = НСтр("ru = 'Непрочитанные'");
	
	СтрокаИсходящие = Дерево.Строки.Добавить();
	СтрокаИсходящие.Значение = "Исходящие";
	СтрокаИсходящие.Представление = НСтр("ru = 'Исходящие'");
	СтрокаИсходящие.ШаблонПредставления = НСтр("ru = 'Исходящие'");
	
	НовЗапись = СтрокаИсходящие.Строки.Добавить();
	НовЗапись.Значение = "ИсходящиеНаПодписи";
	НовЗапись.Представление = НСтр("ru = 'На подписи'");
	НовЗапись.ШаблонПредставления = НСтр("ru = 'На подписи'");
	
	НовЗапись = СтрокаИсходящие.Строки.Добавить();
	НовЗапись.Значение = "ИсходящиеОтклоненные";
	НовЗапись.Представление = НСтр("ru = 'Не доставлены'");
	НовЗапись.ШаблонПредставления = НСтр("ru = 'Не доставлены'");
	
	НовЗапись = СтрокаИсходящие.Строки.Добавить();
	НовЗапись.Значение = "ИсходящиеЧерновики";
	НовЗапись.Представление = НСтр("ru = 'Черновики'");
	НовЗапись.ШаблонПредставления = НСтр("ru = 'Черновики'");
	
	СтрокаИсходящие = Дерево.Строки.Добавить();
	СтрокаИсходящие.Значение = "Корзина";
	СтрокаИсходящие.НомерКартинки = 4;
	СтрокаИсходящие.Представление = НСтр("ru = 'Корзина'");
	СтрокаИсходящие.ШаблонПредставления = НСтр("ru = 'Корзина'");
	
	СтрокаИсходящие = Дерево.Строки.Добавить();
	СтрокаИсходящие.Значение = "Все";
	СтрокаИсходящие.Представление = НСтр("ru = 'Все'");
	СтрокаИсходящие.ШаблонПредставления = НСтр("ru = 'Все'");
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоДействий");
	
КонецПроцедуры

&НаСервере
Процедура СформироватьТаблицуБыстрогоОтбора()
	
	БыстрыеОтборы.Очистить();
	
	НоваяСтрока = БыстрыеОтборы.Добавить();
	НоваяСтрока.Параметр = "Основание";
	НоваяСтрока.ПредставлениеПараметра = НСтр("ru = 'Основание:'");
	НоваяСтрока.Тип = "ОпределяемыеТипы.ВладелецОбменСБанками";
	НоваяСтрока.Значение = Неопределено;
	ПлатежноеПоручение = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении(
		"ПлатежноеПоручениеВМетаданных");
	Если ЗначениеЗаполнено(ПлатежноеПоручение) Тогда
		НоваяСтрока.СписокВыбора.Добавить(Тип("ДокументСсылка." + ПлатежноеПоручение));
	КонецЕсли;
	НоваяСтрока.СписокВыбора.Добавить(Тип("ДокументСсылка.ПисьмоОбменСБанками"));
	
	НоваяСтрока = БыстрыеОтборы.Добавить();
	НоваяСтрока.Параметр = "СчетОрганизации";
	НоваяСтрока.ПредставлениеПараметра = НСтр("ru = 'Счет:'");
	НоваяСтрока.Тип = "ОпределяемыеТипы.СчетОрганизацииОбменСБанками";
	НоваяСтрока.Значение = Неопределено;
	
	ОрганизацииИБанки = ПолучитьИзВременногоХранилища(ТаблицаНастроек);
	
	НазваниеСправочникаОрганизации = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника("Организации");
	Если Не ЗначениеЗаполнено(НазваниеСправочникаОрганизации) Тогда
		НазваниеСправочникаОрганизации = "Организации";
	КонецЕсли;
	
	Организации = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ОрганизацииИБанки.ВыгрузитьКолонку("Организация"));
	
	Если Организации.Количество() = 1 Тогда
		Организация = Организации.Получить(0);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПисьмаОрганизация", "Видимость", Ложь);
	Иначе
		НоваяСтрока = БыстрыеОтборы.Добавить();
		НоваяСтрока.Параметр = "Организация";
		НоваяСтрока.ПредставлениеПараметра = НСтр("ru = 'Организация:'");
		НоваяСтрока.Тип = "СправочникСсылка."+ НазваниеСправочникаОрганизации;
		НоваяСтрока.Значение = Неопределено;
		НоваяСтрока.СписокВыбора.ЗагрузитьЗначения(Организации);
	КонецЕсли;
	
	НазваниеСправочникаБанки = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника("Банки");
	Если Не ЗначениеЗаполнено(НазваниеСправочникаБанки) Тогда
		НазваниеСправочникаБанки = "Банки";
	КонецЕсли;
	
	Банки = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ОрганизацииИБанки.ВыгрузитьКолонку("Банк"));
	
	Если Банки.Количество() = 1 Тогда
		Банк = Банки.Получить(0);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПисьмаБанк", "Видимость", Ложь);
	Иначе
		НоваяСтрока = БыстрыеОтборы.Добавить();
		НоваяСтрока.Параметр = "Банк";
		НоваяСтрока.ПредставлениеПараметра = НСтр("ru = 'Банк:'");
		НоваяСтрока.Тип = "СправочникСсылка."+ НазваниеСправочникаБанки;
		НоваяСтрока.Значение = Неопределено;
		НоваяСтрока.СписокВыбора.ЗагрузитьЗначения(Организации);
	КонецЕсли;

	НоваяСтрока = БыстрыеОтборы.Добавить();
	НоваяСтрока.Параметр = "Тема";
	НоваяСтрока.ПредставлениеПараметра = НСтр("ru = 'Тема:'");
	НоваяСтрока.Тип = "Строка";
	НоваяСтрока.Значение = "";
	
	НоваяСтрока = БыстрыеОтборы.Добавить();
	НоваяСтрока.Параметр = "Текст";
	НоваяСтрока.ПредставлениеПараметра = НСтр("ru = 'Текст:'");
	НоваяСтрока.Тип = "Строка";
	НоваяСтрока.Значение = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовокОтбораНажатие(Элемент)
	
	ПоказатьБыстрыйПоиск = Не ПоказатьБыстрыйПоиск;
	ПоказатьСкрытьБыстрыйПоиск();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьБыстрыйПоиск()
	
	Элементы.ЗаголовокОтбора.Заголовок = НСтр("ru = 'Быстрый поиск'")
		+ ?(ПоказатьБыстрыйПоиск, " " + НСтр("ru = '(скрыть)'"),  " " + НСтр("ru = '(показать)'"));
		
	Элементы.БыстрыеОтборы.Видимость = ПоказатьБыстрыйПоиск;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	// Недоступные поля быстрого отбора при выборе определенных значений отбора
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.БыстрыеОтборыЗначение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("БыстрыеОтборы.Недоступен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра(
		"ЦветТекста", Метаданные.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет.Значение);
	
	// Выделять разделы с количеством жирным шрифтом (кроме черновиков)
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоДействийПредставление.Имя);
	
	ГруппаОтбораИ = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоДействий.Количество");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоДействий.Значение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = "ИсходящиеЧерновики";

	ЭлементШрифтаОформления = Элемент.Оформление.Элементы.Найти("Font");
	ЭлементШрифтаОформления.Значение = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина);
	ЭлементШрифтаОформления.Использование = Истина;
	
	// Выделять непрочтенные письма жирным шрифтом и цветом фона
	УсловноеОформлениеКД = Письма.КомпоновщикНастроек.Настройки.УсловноеОформление;
	УсловноеОформлениеКД.ИдентификаторПользовательскойНастройки = "ОсновноеОформление";
	
	ЭлементУсловногоОформления = УсловноеОформлениеКД.Элементы.Добавить();

	ЭлементУсловногоОформления.Использование = Истина;
	
	ПредставлениеЭлемента = НСтр("ru = 'Выделять непрочтенные письма жирным шрифтом и цветом фона (стандартная настройка)'");
	ЭлементУсловногоОформления.Представление = ПредставлениеЭлемента;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Прочитано");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Направление");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Перечисления.НаправленияЭД.Входящий;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементШрифтаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Font");
	ЭлементШрифтаОформления.Значение = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина);
	ЭлементШрифтаОформления.Использование = Истина;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("BackColor", ЦветаСтиля.ЦветФонаПоля);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРаздела(Знач НовыйРаздел)
	
	ТекущийРаздел = НовыйРаздел;
	
	ГруппаОтборПоРазделам = ОбщегоНазначенияКлиентСервер.НайтиЭлементОтбораПоПредставлению(
		Письма.Отбор.Элементы, "ОтборПоРазделам");
		
	Если ГруппаОтборПоРазделам = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ГруппаОтборПоРазделам.Использование = Истина;
	
	// Включаем использование группы отбора, соответствующей разделу.
	РазделНайден = Ложь;
	Для каждого ГруппаРаздела Из ГруппаОтборПоРазделам.Элементы Цикл
		Если ГруппаРаздела.Представление = НовыйРаздел Тогда
			ГруппаРаздела.Использование = Истина;
			РазделНайден = Истина;
		Иначе
			ГруппаРаздела.Использование = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	// Если не удалось найти группу раздела, то включаем все разделы.
	Если Не РазделНайден Тогда
		ГруппаОтборПоРазделам.Использование = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьОтборПоРазделамВСпискахРазделов()
	
	Разделы = Новый Массив;
	
	Разделы.Добавить("Входящие");
	Разделы.Добавить("ВходящиеНепрочитанные");
	Разделы.Добавить("Исходящие");
	Разделы.Добавить("ИсходящиеНаПодписи");
	Разделы.Добавить("ИсходящиеОжидаютОтвета");
	Разделы.Добавить("ИсходящиеОтклоненные");
	Разделы.Добавить("ИсходящиеЧерновики");
	Разделы.Добавить("Корзина");
	Разделы.Добавить("Все");
	
	ГруппаОтборПоРазделам = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		Письма.Отбор.Элементы, "ОтборПоРазделам", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
	
	Для каждого Раздел Из Разделы Цикл
		
		ГруппаРаздел = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
			ГруппаОтборПоРазделам, Раздел, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
			
		СоздатьОтборПоРазделу(Раздел, ГруппаРаздел);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьОтборПоРазделу(Знач Раздел, ГруппаОтбора)
	
	// Изменения в отборы вносить согласовано с текстами запросов количества элементов в разделе.
	// См. метод ТекстЗапросаКоличестваЭлементовПоРазделуБезОтбора.
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "ПометкаУдаления", Ложь, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	
	Если Раздел = "Входящие" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "Направление", Перечисления.НаправленияЭД.Входящий, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	
	ИначеЕсли Раздел = "ВходящиеНепрочитанные" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "Направление", Перечисления.НаправленияЭД.Входящий, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "Прочитано", Ложь, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
	ИначеЕсли Раздел = "Исходящие" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "Направление", Перечисления.НаправленияЭД.Исходящий, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	
	ИначеЕсли Раздел = "ИсходящиеНаПодписи" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "Направление", Перечисления.НаправленияЭД.Исходящий, ВидСравненияКомпоновкиДанных.Равно, , Истина);
			
		МассивОтбора = Новый Массив;
		МассивОтбора.Добавить(Перечисления.СтатусыОбменСБанками.ЧастичноПодписан);
		МассивОтбора.Добавить(Перечисления.СтатусыОбменСБанками.НеПодтвержден);
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Статус", МассивОтбора,
			ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
			
	ИначеЕсли Раздел = "ИсходящиеОтклоненные" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "Направление", Перечисления.НаправленияЭД.Исходящий, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "Статус",
			Перечисления.СтатусыОбменСБанками.ОтклоненБанком, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
	ИначеЕсли Раздел = "ИсходящиеЧерновики" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "Направление", Перечисления.НаправленияЭД.Исходящий, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "Статус", Перечисления.СтатусыОбменСБанками.Черновик, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
	ИначеЕсли Раздел = "Корзина" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "ПометкаУдаления", Истина, ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПисьмаПриИзменении(Элемент)
	
	Если Не ЗаданиеВыполняется Тогда
		РезультатЗаданияРасчетаКоличестваПоРазделам = ЗапускЗаданияОбновленияКоличестваПоРазделам(УникальныйИдентификатор);
		ПодключитьОбработчикОжидания("ОбновитьКоличествоВРазделах", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти