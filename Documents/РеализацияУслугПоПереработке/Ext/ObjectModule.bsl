﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет табличную часть Материалы на основании данных табличных частей Продукция и Услуги.
// Счета учета не заполняются. При необходимости, об этом должен позаботиться вызывающий код.
// 
Процедура ЗаполнитьМатериалыПоПродукцииУслугам() Экспорт
	
	// Получим данные о сырье для заполнения табличной части
	ЭлементыТекстаЗапроса = Новый Массив;
	// Исходные данные
	ЭлементыТекстаЗапроса.Добавить(
		"ВЫБРАТЬ
		|	0 КАК НомерСписка,
		|	Услуги.НомерСтроки КАК НомерСтроки,
		|	Услуги.Номенклатура КАК НоменклатураПродукции,
		|	Услуги.Спецификация КАК Спецификация,
		|	Услуги.Количество КАК КоличествоПродукции
		|ПОМЕСТИТЬ Выпуск
		|ИЗ
		|	&Услуги КАК Услуги");
	
	// Данные о расходе сырья
	ЭлементыТекстаЗапроса.Добавить(УправлениеПроизводством.ТекстЗапросаВременнаяТаблицаЗатратыСырья());
	
	// Преобразуем в формат получателя
	ЭлементыТекстаЗапроса.Добавить(
		"ВЫБРАТЬ
		|	МАКСИМУМ(ЗатратыСырья.НомерСтрокиСпецификации) КАК НомерСтрокиСпецификации,
		|	МИНИМУМ(ЗатратыСырья.НомерСписка) КАК НомерСписка,
		|	ЗатратыСырья.Номенклатура КАК Номенклатура,
		|	ЗатратыСырья.Номенклатура.Наименование КАК НоменклатураПредставление,
		|	СУММА(ЗатратыСырья.Количество) КАК Количество,
		|	ЗатратыСырья.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ЗатратыСырья.СтатьяЗатрат КАК СтатьяЗатрат
		|ИЗ
		|	ЗатратыСырья КАК ЗатратыСырья
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗатратыСырья.Номенклатура,
		|	ЗатратыСырья.Номенклатура.Наименование,
		|	ЗатратыСырья.ЕдиницаИзмерения,
		|	ЗатратыСырья.СтатьяЗатрат
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСписка,
		|	НомерСтрокиСпецификации,
		|	НоменклатураПредставление");
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Услуги", Услуги.Выгрузить());
	Запрос.Текст = СтрСоединить(ЭлементыТекстаЗапроса, ОбщегоНазначенияБПСервер.ТекстРазделителяЗапросовПакета());
	
	МатериалыЗаказчика.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

// Заполняет табличную часть Материалы остатками Контрагента.
// 
Процедура ЗаполнитьМатериалыПоОстаткамКонтрагента(ДатаДокумента) Экспорт
	
	// Остатки по счету Z022.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Субконто2 КАК Номенклатура,
		|	ХозрасчетныйОстатки.КоличествоОстатокДт КАК Количество,
		|	ХозрасчетныйОстатки.Счет КАК СчетУчета
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период,
		|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МатериалыПринятыеВПереработкуВПроизводстве),
		|			&ВидыСубконто,
		|			Организация = &Организация
		|				И Субконто1 = &Контрагент) КАК ХозрасчетныйОстатки";
	
	Запрос.УстановитьПараметр("Период", ДатаДокумента);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	ВидыСубконто= Новый Массив;
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);
	
	МатериалыЗаказчика.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
	Если НЕ ЗначениеЗаполнено(ДатаСФ) Тогда 
		ДатаСФ = ТекущаяДатаСеанса();	
	КонецЕсли;	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Проверка заполнения табличных частей
	ПроверяемыеРеквизиты.Добавить("Услуги");
	ПроверяемыеРеквизиты.Добавить("МатериалыЗаказчика");
			
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

	СуммаДокумента = Услуги.Итог("Всего");
		
	Если (ЗначениеЗаполнено(СерияБланкаСФ) Или ЗначениеЗаполнено(НомерБланкаСФ)) И Не ЗначениеЗаполнено(ДатаСФ) Тогда 
		ДатаСФ = Дата;
	КонецЕсли;

	РассчитатьСуммыВРегламентированнойВалюте();	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ИнициализироватьДанные(Отказ, РежимПроведения);
	
	ОтразитьДвижения(Отказ, РежимПроведения);
		
	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	СерияБланкаСФ = "";
	НомерБланкаСФ = "";
	ДатаСФ = '00010101';
	
	СтруктураДанные = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ДоговорКонтрагента.ВалютаРасчетов, Дата);
	Курс      = ?(СтруктураДанные.Курс = 0, 1, СтруктураДанные.Курс);
	Кратность = ?(СтруктураДанные.Кратность = 0, 1, СтруктураДанные.Кратность);
	
	КурсНБКР      = ?(СтруктураДанные.Курс = 0, 1, СтруктураДанные.Курс);
	КратностьНБКР = ?(СтруктураДанные.Кратность = 0, 1, СтруктураДанные.Кратность);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииОбработкаПроведения

// Процедура инициализирует данные документа
// и подготавливает таблицы для движения в регистры
//
Процедура ИнициализироватьДанные(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.РеализацияУслугПоПереработке.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры
	
// Процедура заполняет регистры данными
//
Процедура ОтразитьДвижения(Отказ, РежимПроведения)

	// Отражение в разделах учета.
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСписанныеТовары, 
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты, Движения, Отказ, ДополнительныеСвойства);
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСписанныеМатериалыЗаказчика, 
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты, Движения, Отказ, ДополнительныеСвойства);
		
	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура рассчитывает суммы табличных частей в валюте регламентированного учета
//
Процедура РассчитатьСуммыВРегламентированнойВалюте()

	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Если ВалютаДокумента = ВалютаРегламентированногоУчета Тогда
		
		МассивТабличныхЧастей = Новый Массив();
		МассивТабличныхЧастей.Добавить(Услуги);
		
		Для Каждого ТабличнаяЧасть Из МассивТабличныхЧастей Цикл
			Для Каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл					
				СтрокаТабличнойЧасти.СуммаВВалютеРеглУчета 		 		= СтрокаТабличнойЧасти.Сумма;
				СтрокаТабличнойЧасти.СуммаНДСВВалютеРеглУчета 	 		= СтрокаТабличнойЧасти.СуммаНДС;
				СтрокаТабличнойЧасти.СуммаНСПВВалютеРеглУчета 	 		= СтрокаТабличнойЧасти.СуммаНСП;
				СтрокаТабличнойЧасти.СуммаДоходаВВалютеРеглУчета 		= СтрокаТабличнойЧасти.СуммаДохода;
				СтрокаТабличнойЧасти.ВсегоВВалютеРеглУчета 				= СтрокаТабличнойЧасти.Всего;
			КонецЦикла;
		КонецЦикла;
		
	Иначе
		ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(Дата, Организация);	
		МассивТабличныхЧастей = Новый Массив();
		МассивТабличныхЧастей.Добавить(Услуги);
		
		СтавкаНДСДляРасчета = ?(ДанныеУчетнойПолитики.ПлательщикНДС, 
								СтавкаНДС, 
								Справочники.СтавкиНДС.ПустаяСсылка());
								
		Для Каждого ТабличнаяЧасть Из МассивТабличныхЧастей Цикл
			
			ИмяТабличнойЧасти = "Услуги";	
			ПараметрыРасчета = ПодготовитьПараметрыРасчета(ИмяТабличнойЧасти, ДанныеУчетнойПолитики);
										
			Для Каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		
				// Структура для пересчета и заполнения суммами в валюте регламетированного учета.
				ДанныеВВалютеРеглУчета = Новый Структура();	
				ДанныеВВалютеРеглУчета.Вставить("Всего", СтрокаТабличнойЧасти.Всего);
				ДанныеВВалютеРеглУчета.Вставить("СуммаНДС", СтрокаТабличнойЧасти.СуммаНДС);
				ДанныеВВалютеРеглУчета.Вставить("СуммаНСП", СтрокаТабличнойЧасти.СуммаНСП);
				ДанныеВВалютеРеглУчета.Вставить("СтавкаНДС", ПараметрыРасчета.СтавкаНДС);
				ДанныеВВалютеРеглУчета.Вставить("СтавкаНСП", ПараметрыРасчета.СтавкаНСП);
		
				Если СуммаВключаетНалоги Тогда
					ДанныеВВалютеРеглУчета.Вставить("Сумма", Окр(СтрокаТабличнойЧасти.Сумма * Курс / Кратность, 2));
					ДанныеВВалютеРеглУчета.Вставить("СуммаДохода", СтрокаТабличнойЧасти.СуммаДохода);	
				Иначе
					ДанныеВВалютеРеглУчета.Вставить("Сумма", СтрокаТабличнойЧасти.Сумма);
					ДанныеВВалютеРеглУчета.Вставить("СуммаДохода", Окр(СтрокаТабличнойЧасти.СуммаДохода * Курс / Кратность, 2));	
				КонецЕсли;
				
				ДанныеВВалютеРеглУчета.Вставить("Цена", Окр(СтрокаТабличнойЧасти.Цена * Курс / Кратность, 2));
				ДанныеВВалютеРеглУчета.Вставить("Количество", СтрокаТабличнойЧасти.Количество);	
				
				Если СуммаВключаетНалоги Тогда					
					ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(ДанныеВВалютеРеглУчета, ПараметрыРасчета);	
					ОбработкаТабличныхЧастейКлиентСервер.РассчитатьВсегоСтрокиТабличнойЧасти(ДанныеВВалютеРеглУчета);
					ОбработкаТабличныхЧастейКлиентСервер.РассчитатьДоходСтрокиТабличнойЧасти(ДанныеВВалютеРеглУчета, Истина);
					
				Иначе
					ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(ДанныеВВалютеРеглУчета, ПараметрыРасчета);	
					ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммыНалоговСтрокиТабличнойЧасти(ДанныеВВалютеРеглУчета, ПараметрыРасчета);		
					ОбработкаТабличныхЧастейКлиентСервер.РассчитатьВсегоСтрокиТабличнойЧасти(ДанныеВВалютеРеглУчета);
				КонецЕсли;
					
				СтрокаТабличнойЧасти.СуммаВВалютеРеглУчета 		 		= ДанныеВВалютеРеглУчета.Сумма;
				СтрокаТабличнойЧасти.СуммаНДСВВалютеРеглУчета 	 		= ДанныеВВалютеРеглУчета.СуммаНДС;
				СтрокаТабличнойЧасти.СуммаНСПВВалютеРеглУчета 	 		= ДанныеВВалютеРеглУчета.СуммаНСП;
				СтрокаТабличнойЧасти.СуммаДоходаВВалютеРеглУчета 		= ДанныеВВалютеРеглУчета.СуммаДохода;
				СтрокаТабличнойЧасти.ВсегоВВалютеРеглУчета 		 		= ДанныеВВалютеРеглУчета.Всего;
			КонецЦикла;	
		КонецЦикла;			
	КонецЕсли;	
КонецПроцедуры

Функция ПодготовитьПараметрыРасчета(ИмяТабличнойЧасти, ДанныеУчетнойПолитики, СчитатьОтДохода = Ложь) Экспорт

	ПараметрыРасчета = Новый Структура;
	ПараметрыРасчета.Вставить("Период", 					Дата);
	ПараметрыРасчета.Вставить("Организация", 				Организация);
	ПараметрыРасчета.Вставить("ПризнакСтраныЕАЭС", 			Ложь);
	ПараметрыРасчета.Вставить("ПризнакСтраныИмпортЭкспорт", Ложь);
	
	
	// СуммаВключаетНалоги - всегда ИСТИНА, потому что расчет налогов идет от "Всего", а "Всего" всегда с налогами.
	ПараметрыРасчета.Вставить("СуммаВключаетНалоги", 		Истина);
	
	ПараметрыРасчета.Вставить("БезналичныйРасчет", БезналичныйРасчет);
	ПараметрыРасчета.Вставить("СчитатьОтДохода", СчитатьОтДохода);
	ПараметрыРасчета.Вставить("ИмяТабличнойЧасти", ИмяТабличнойЧасти);
	ПараметрыРасчета.Вставить("Точность", 2);
	ПараметрыРасчета.Вставить("СтавкаНДС", ?(ДанныеУчетнойПолитики.ПлательщикНДС, 
												СтавкаНДС, Справочники.СтавкиНДС.ПустаяСсылка()));
	ПараметрыРасчета.Вставить("СтавкаНСП", ?(ДанныеУчетнойПолитики.ПлательщикНСП, 
												СтавкаНСП, Справочники.СтавкиНСП.ПустаяСсылка()));
	
	Возврат ПараметрыРасчета;
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли