﻿#Область ПрограммныйИнтерфейс

Процедура ОповеститьОЗавершении(Форма, ИмяРегистра, ВедущийОбъект) Экспорт
	
	ПараметрОповещения = Новый Структура("ИмяРегистра,МассивЗаписей", ИмяРегистра, Форма.НаборЗаписей);
	Оповестить("ОтредактированаИстория", ПараметрОповещения, ВедущийОбъект);
	Форма.Закрыть();
	
КонецПроцедуры

Процедура ОповеститьОЗавершенииПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов) Экспорт
	
	ПараметрОповещения = Новый Структура("ИмяРегистра,МассивЗаписей", ИмяРегистра, Форма.НаборЗаписей);
	Оповестить("ОтредактированаИстория", ПараметрОповещения, СтруктураВедущихОбъектов);
	Форма.Закрыть();
	
КонецПроцедуры

Процедура ОткрытьИсторию(ИмяРегистра, ВедущийОбъект, Форма, ТолькоПросмотр) Экспорт
	
	МассивЗаписей = МассивЗаписейИстории(Форма, ИмяРегистра, ВедущийОбъект);
	ПараметрыФормы = Новый Структура("МассивЗаписей,ВедущийОбъект,ТолькоПросмотр", МассивЗаписей, ВедущийОбъект, ТолькоПросмотр);
	ОткрытьФорму("РегистрСведений." + ИмяРегистра + ".Форма.РедактированиеИстории" , ПараметрыФормы, Форма);
	
КонецПроцедуры

Процедура ОткрытьИсториюПоСтруктуре(ИмяРегистра, СтруктураВедущихОбъектов, Форма, ТолькоПросмотр) Экспорт
	
	МассивЗаписей = МассивЗаписейИсторииПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов);
	ПараметрыФормы = Новый Структура("МассивЗаписей,СтруктураВедущихОбъектов,ТолькоПросмотр", МассивЗаписей, СтруктураВедущихОбъектов, ТолькоПросмотр);
	ОткрытьФорму("РегистрСведений." + ИмяРегистра + ".Форма.РедактированиеИстории" , ПараметрыФормы, Форма);
	
КонецПроцедуры

// Запрос режима записи периодических регистров при редактировании в форме ведущего объекта
// Параметры
//	Форма
//	ИмяРегистра
//	ТекстЗапроса - текст вопроса пользователю
//	ТекстКнопкиДа - текст кнопки, подтверждающей, что нужно ввести новую запись
//	Отказ
//	ОповещениеЗавершения - описание оповещения, выполняемого после завершения процедуры
//
// см. также 
//	ЗарплатаКадры.ЗаписатьЗаписьПослеРедактированияВФорме
// 	ЗарплатаКадры.ПрочитатьЗаписьДляРедактированияВФорме
Процедура ЗапроситьРежимИзмененияРегистра(Форма, ИмяРегистра, ТекстЗапроса, ТекстКнопкиДа, Отказ, ОповещениеЗавершения = Неопределено) Экспорт
	// Требуется запрашивать пользователя об изменении только если еще не принято решение, что запись - новая
	Если Форма[ИмяРегистра + "НоваяЗапись"] = Истина Тогда
		Если ОповещениеЗавершения <> Неопределено Тогда 
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
		КонецЕсли;
		Возврат;
	КонецЕсли;

	// Требуется запрашивать пользователя об изменении только если задана дата записи
	Если Не ЗначениеЗаполнено(Форма[ИмяРегистра].Период) Тогда
		Если ОповещениеЗавершения <> Неопределено Тогда 
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// Требуется запрашивать пользователя об изменении только если была считана прежняя запись
	Если Не ЗначениеЗаполнено(Форма[ИмяРегистра + "Прежняя"].Период) Тогда
		Если ОповещениеЗавершения <> Неопределено Тогда 
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ИзменилсяПериод = (Форма[ИмяРегистра].Период <> Форма[ИмяРегистра + "Прежняя"].Период);
	ИзменилисьДанные = Ложь;
	Для Каждого Поле Из Форма[ИмяРегистра + "Прежняя"] Цикл
		Если Поле.Ключ = "Период" Тогда
			Продолжить;
		КонецЕсли;
		ИзменилисьДанные = Форма[ИмяРегистра][Поле.Ключ] <> Поле.Значение;
		Если ИзменилисьДанные Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	// Требуется запрашивать пользователя об изменении - изменили и текущие данные, и дату записи
	Если ИзменилисьДанные И ИзменилсяПериод Тогда
		
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Нет,  	НСтр("ru = 'Исправлена ошибка'"));
		Кнопки.Добавить(КодВозвратаДиалога.Да, 		ТекстКнопкиДа);
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, 	НСтр("ru = 'Отмена'"));
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		ДополнительныеПараметры.Вставить("Отказ", Отказ);
		ДополнительныеПараметры.Вставить("ИмяРегистра", ИмяРегистра);
		ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
		
		Оповещение = Новый ОписаниеОповещения("ЗапроситьРежимИзмененияРегистраЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстЗапроса, Кнопки, , КодВозвратаДиалога.Отмена);
		
	Иначе
		
		Если ОповещениеЗавершения <> Неопределено Тогда 
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ЗапроситьРежимИзмененияРегистраЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	Отказ = ДополнительныеПараметры.Отказ;
	ИмяРегистра = ДополнительныеПараметры.ИмяРегистра;
	ОповещениеЗавершения = ДополнительныеПараметры.ОповещениеЗавершения;
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Отказ = Истина;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		Форма[ИмяРегистра + "НоваяЗапись"] = Истина;
	КонецЕсли;
	
	Если ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаОповещения(Форма, ВедущийОбъект, ИмяСобытия, Параметр, Источник, ВедущийОбъектКакСтруктура = Ложь) Экспорт
	
	Если НЕ Форма.ТолькоПросмотр И ИмяСобытия = "ОтредактированаИстория" Тогда
		ЗначениеОповещения = Истина;
		Если ВедущийОбъектКакСтруктура Тогда
			Если Источник.Количество() <> ВедущийОбъект.Количество() Тогда
				ЗначениеОповещения = Ложь;
			Иначе
				Для Каждого ЭлементСтруктуры1 Из Источник Цикл
					ЗначениеСтруктуры = Неопределено;
					Если ВедущийОбъект.Свойство(ЭлементСтруктуры1.Ключ, ЗначениеСтруктуры) Тогда
						Если ЗначениеСтруктуры <> ЭлементСтруктуры1.Значение Тогда
							ЗначениеОповещения = Ложь;
							Прервать;
						КонецЕсли;
					Иначе
						ЗначениеОповещения = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		Иначе
			Если ВедущийОбъект <> Источник Тогда
				ЗначениеОповещения = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ЗначениеОповещения Тогда
			Возврат;
		КонецЕсли;
		
		КоллекцииИдентичны = КоллекцииНаборовИдентичны(Форма[Параметр.ИмяРегистра + "НаборЗаписей"], Параметр.МассивЗаписей, ОбщегоНазначенияКлиентСервер.КлючиСтруктурыВСтроку(Форма[Параметр.ИмяРегистра + "Прежняя"]));
		Если НЕ КоллекцииИдентичны Тогда
			НаборЗаписей = Форма[Параметр.ИмяРегистра + "НаборЗаписей"];
			НаборЗаписей.Очистить();
			Для Каждого Строка Из Параметр.МассивЗаписей Цикл
				ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Строка);
			КонецЦикла;
			НаборЗаписей.Сортировать("Период");
			Если НаборЗаписей.Количество() > 0 Тогда
				ПоследняяЗапись = НаборЗаписей[НаборЗаписей.Количество()-1];
				СтруктураЗаписи = Новый Структура();
				Для Каждого КлючЗначение Из Форма[Параметр.ИмяРегистра + "Прежняя"] Цикл
					СтруктураЗаписи.Вставить(КлючЗначение.Ключ, ПоследняяЗапись[КлючЗначение.Ключ]);
				КонецЦикла;
				Форма[Параметр.ИмяРегистра + "Прежняя"] = Новый ФиксированнаяСтруктура(СтруктураЗаписи);
			Иначе
				Если ВедущийОбъектКакСтруктура Тогда
					МенеджерЗаписи = РедактированиеПериодическихСведенийВызовСервера.СтруктураМенеджераЗаписиПоСтруктуре(Параметр.ИмяРегистра, ВедущийОбъект);
				Иначе
					МенеджерЗаписи = РедактированиеПериодическихСведенийВызовСервера.СтруктураМенеджераЗаписи(Параметр.ИмяРегистра, ВедущийОбъект);
				КонецЕсли;
				СтруктураЗаписи = Новый Структура();
				Для Каждого КлючЗначение Из Форма[Параметр.ИмяРегистра + "Прежняя"] Цикл
					СтруктураЗаписи.Вставить(КлючЗначение.Ключ, МенеджерЗаписи[КлючЗначение.Ключ]);
				КонецЦикла;
				Форма[Параметр.ИмяРегистра + "Прежняя"] = Новый ФиксированнаяСтруктура(СтруктураЗаписи);
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(Форма[Параметр.ИмяРегистра], Форма[Параметр.ИмяРегистра + "Прежняя"]);
			Форма.Модифицированность = Истина;
			Если ВедущийОбъектКакСтруктура Тогда
				РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВводаПоСтруктуре(Форма, Параметр.ИмяРегистра, ВедущийОбъект);
			Иначе
				РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(Форма, Параметр.ИмяРегистра, ВедущийОбъект);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаОповещенияПоСтруктуре(Форма, СтруктураВедущихОбъектов, ИмяСобытия, Параметр, Источник) Экспорт
	
	ОбработкаОповещения(Форма, СтруктураВедущихОбъектов, ИмяСобытия, Параметр, Источник, Истина);
	
КонецПроцедуры

Функция КоллекцииНаборовИдентичны(Набор1, Набор2, СписокПолей) Экспорт
	
	Если Набор1.Количество() <> Набор2.Количество() Тогда
		Возврат Ложь;
	КонецЕсли; 
	
	Для каждого СтрокаНабор1 Из Набор1 Цикл
		
		СтрокиНабор2 = Набор2.НайтиСтроки(Новый Структура("Период", СтрокаНабор1.Период));
		Если СтрокиНабор2.Количество() = 0 Тогда
			Возврат Ложь;
		КонецЕсли; 
		СтрокаНабор2 = СтрокиНабор2[0];
		
		СтруктураСтрокиНабор1 = Новый Структура(СписокПолей);
		ЗаполнитьЗначенияСвойств(СтруктураСтрокиНабор1, СтрокаНабор1);
		
		СтруктураСтрокиНабор2 = Новый Структура(СписокПолей);
		ЗаполнитьЗначенияСвойств(СтруктураСтрокиНабор2, СтрокаНабор2);
		
		Для каждого ЭлементСтруктуры Из СтруктураСтрокиНабор1 Цикл
			Если ЭлементСтруктуры.Значение <> СтруктураСтрокиНабор2[ЭлементСтруктуры.Ключ] Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Процедура УпорядочитьНаборЗаписейВФорме(Форма) Экспорт
	
	ИдентификаторТекущейСтроки = Форма.Элементы.НаборЗаписей.ТекущаяСтрока;
	Если ИдентификаторТекущейСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = Форма.НаборЗаписей;
	ТекущаяСтрока = НаборЗаписей.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ИндексТекущейСтроки = НаборЗаписей.Индекс(ТекущаяСтрока);
	КоличествоЗаписей = НаборЗаписей.Количество();
	СдвигаемаяЗапись = НаборЗаписей[ИндексТекущейСтроки];
	
	Смещение = 0;
	
	Если ИндексТекущейСтроки > 0 Тогда
		Для СдвигИндексаЗаписи = КоличествоЗаписей - ИндексТекущейСтроки По КоличествоЗаписей - 1 Цикл
			Запись = НаборЗаписей[КоличествоЗаписей - 1 - СдвигИндексаЗаписи];
			Если СдвигаемаяЗапись.Период > Запись.Период Тогда
				Прервать;
			КонецЕсли; 
			Смещение = Смещение - 1;
		КонецЦикла;
	КонецЕсли;
	
	Если Смещение = 0 И ИндексТекущейСтроки < КоличествоЗаписей - 1 Тогда
		Для ИндексЗаписи = ИндексТекущейСтроки + 1 По КоличествоЗаписей - 1 Цикл
			Запись = НаборЗаписей[ИндексЗаписи];
			Если СдвигаемаяЗапись.Период < Запись.Период Тогда
				Прервать;
			КонецЕсли; 
			Смещение = Смещение + 1;
		КонецЦикла;
	КонецЕсли;
	
	Если Смещение <> 0 Тогда
		НаборЗаписей.Сдвинуть(ИндексТекущейСтроки, Смещение);
	КонецЕсли; 
	
КонецПроцедуры

Функция МассивЗаписейИстории(Форма, ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьНаборЗаписейИстории(Форма, ИмяРегистра, ВедущийОбъект);
	
	Возврат МассивЗаписейИсторииВФорме(Форма, ИмяРегистра);
	
КонецФункции

Функция МассивЗаписейИсторииПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов) Экспорт
	
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьНаборЗаписейИсторииПоСтруктуре(Форма, ИмяРегистра, СтруктураВедущихОбъектов);
	
	Возврат МассивЗаписейИсторииВФорме(Форма, ИмяРегистра);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция МассивЗаписейИсторииВФорме(Форма, ИмяРегистра)
	
	СтруктураЗаписиСтрокой = "";
	НужнаЗапятая = Ложь;
	Для Каждого КлючЗначение Из Форма[ИмяРегистра + "Прежняя"] Цикл
		Если НужнаЗапятая Тогда
			СтруктураЗаписиСтрокой = СтруктураЗаписиСтрокой + ",";
		КонецЕсли;
		СтруктураЗаписиСтрокой = СтруктураЗаписиСтрокой + КлючЗначение.Ключ;
		НужнаЗапятая = Истина;
	КонецЦикла;
	
	Массив = Новый Массив();
	Для Каждого Строка Из Форма[ИмяРегистра + "НаборЗаписей"] Цикл
		НоваяСтрока = Новый Структура(СтруктураЗаписиСтрокой);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		Массив.Добавить(НоваяСтрока);
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти