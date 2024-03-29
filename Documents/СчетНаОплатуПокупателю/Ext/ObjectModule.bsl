﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоРеализацииТоваровУслуг(ДанныеЗаполнения) Экспорт
	
	ДокументОснование = ДанныеЗаполнения;
	
	Организация				= ДанныеЗаполнения.Организация;
	БезналичныйРасчет		= ДанныеЗаполнения.БезналичныйРасчет;
	Склад					= ДанныеЗаполнения.Склад;
	// Сведения о контрагенте
	Контрагент          	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента  	= ДанныеЗаполнения.ДоговорКонтрагента;
	// Валюта
	ВалютаДокумента     	= ДанныеЗаполнения.ВалютаДокумента;
	Курс					= ДанныеЗаполнения.Курс;
	Кратность				= ДанныеЗаполнения.Кратность;
	// Налоги
	СтавкаНДС				= ДанныеЗаполнения.СтавкаНДС;
	СтавкаНСП				= ДанныеЗаполнения.СтавкаНСП;
	СтавкаНСПУслуги			= ДанныеЗаполнения.СтавкаНСПУслуги;
	СуммаВключаетНалоги		= ДанныеЗаполнения.СуммаВключаетНалоги;
	// Скидки
	ВидСкидкиНаценки    	= ДанныеЗаполнения.ВидСкидкиНаценки;
	ПроцентСкидкиНаценки 	= ДанныеЗаполнения.ПроцентСкидкиНаценки;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Товары Цикл
		НоваяСтрокаТабличнойЧасти = Товары.Добавить();	
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СтрокаТабличнойЧасти);
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Услуги Цикл
		НоваяСтрокаТабличнойЧасти = Услуги.Добавить();	
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СтрокаТабличнойЧасти);
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.ОС Цикл
		НоваяСтрокаТабличнойЧасти = ОС.Добавить();	
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СтрокаТабличнойЧасти);
	КонецЦикла;

	СуммаДокумента = Товары.Итог("Всего") + Услуги.Итог("Всего") + ОС.Итог("Всего");
	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоЗаказуНаПроизводство(ДанныеЗаполнения) Экспорт
	
	ДокументОснование = ДанныеЗаполнения;
	
	Организация				= ДанныеЗаполнения.Организация;
	Склад					= ДанныеЗаполнения.Склад;
	
	// Сведения о контрагенте
	Контрагент          	= ДанныеЗаполнения.Контрагент;
	ДоговорКонтрагента  	= ДанныеЗаполнения.ДоговорКонтрагента;
	
	// Валюта
	ВалютаДокумента     		= ДанныеЗаполнения.ВалютаДокумента;
	ВалютаРасчетовКурсКратность = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ДанныеЗаполнения.ДоговорКонтрагента.ВалютаРасчетов, ДокументОснование.Дата);
	Курс 		= ?(ВалютаРасчетовКурсКратность.Курс = 0, 1, ВалютаРасчетовКурсКратность.Курс);
	Кратность 	= ?(ВалютаРасчетовКурсКратность.Кратность = 0, 1, ВалютаРасчетовКурсКратность.Кратность);
	
	// Налоги
	СтавкаНДС				= ДанныеЗаполнения.СтавкаНДС;
	СтавкаНСП				= ДанныеЗаполнения.СтавкаНСП;
	СуммаВключаетНалоги		= ДанныеЗаполнения.ДоговорКонтрагента.СуммаВключаетНалоги;
	
	// Скидки
	ОбщийПроцент 	= ДанныеЗаполнения.Продукция.Итог("ПроцентСкидкиНаценки");
	ОбщаяСкидка 	= ДанныеЗаполнения.Продукция.Итог("СуммаСкидки");
	
	Если ОбщийПроцент > 0 Тогда
		ВидСкидкиНаценки = Перечисления.ВидыСкидокНаценок.ПроцентПоСтроке;	
	ИначеЕсли ОбщаяСкидка > 0 Тогда	
		ВидСкидкиНаценки = Перечисления.ВидыСкидокНаценок.СуммаПоСтроке;
	КонецЕсли;
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Продукция Цикл
		НоваяСтрокаТабличнойЧасти = Товары.Добавить();	
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СтрокаТабличнойЧасти);
		НоваяСтрокаТабличнойЧасти.Всего = НоваяСтрокаТабличнойЧасти.Сумма;
	КонецЦикла;

	СуммаДокумента = Товары.Итог("Всего");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.РеализацияТоваровУслуг")] = "ЗаполнитьПоРеализацииТоваровУслуг";
	СтратегияЗаполнения[Тип("ДокументСсылка.ЗаказНаПроизводство")] = "ЗаполнитьПоЗаказуНаПроизводство";
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	// Проверка заполнения табличных частей
	Если Товары.Количество() = 0
		И Услуги.Количество() = 0
		И ОС.Количество() = 0 Тогда	
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Не заполнен ни один список.'"),,,,Отказ);
	КонецЕсли;
			
	Если Товары.Количество() = 0 Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНСП");
	КонецЕсли;	
		
	Если Услуги.Количество() = 0 Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНСПУслуги");
	КонецЕсли;
	
	Если БезналичныйРасчет Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНСП");
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНСПУслуги");
	КонецЕсли;	
		
	Если Товары.Количество() = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;

	Если Курс = 0 Или Кратность = 0 Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнен курс валюты ""%1"". Откройте список валют (Банк и касса - Валюты) и проверьте,
			|что у валюты ""%1"" установлен курс на дату %2 или ранее.
			|Перевыберите договор и заново проведите документ.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ВалютаДокумента, Формат(Дата, "ДЛФ=D"));	
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;

	ОбщегоНазначенияБПСервер.ДобавитьНепроверяемыеРеквизитыПоПараметрамФункциональныхОпций(МассивНепроверяемыхРеквизитов, Организация, Дата);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = Товары.Итог("Всего") + Услуги.Итог("Всего") + ОС.Итог("Всего");
	
КонецПроцедуры

// Процедура - обработчик события ПередУдалением объекта.
//
Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Необходимо проверить, есть ли запись с документом в служебном регистре ДанныеМонитораРуководителя.
	// Если записи есть, необходимо очистить весь раздел данных монитора руководителя.
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеМонитораРуководителя.Организация
	|ИЗ
	|	РегистрСведений.ДанныеМонитораРуководителя КАК ДанныеМонитораРуководителя
	|ГДЕ
	|	ДанныеМонитораРуководителя.ДанныеРасшифровки = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Набор = РегистрыСведений.ДанныеМонитораРуководителя.СоздатьНаборЗаписей();
		
		Набор.Отбор.Организация.Установить(Организация);
		Набор.Отбор.РазделМонитора.Установить(Перечисления.РазделыМонитораРуководителя.НеоплаченныеСчетаПокупателям);
		
		Набор.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли