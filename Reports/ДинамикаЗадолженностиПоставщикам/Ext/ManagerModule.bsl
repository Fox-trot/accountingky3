﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Для подсистемы "Варианты отчетов" при работе в модели сервиса.
//
// Возвращаемое значение:
//  Массив - массив структур (варианты отчета).
Функция ВариантыНастроек() Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Новый Структура("Имя, Представление", "ДинамикаЗадолженностиПоставщикам", НСтр("ru = 'Динамика задолженности поставщикам'")));
КонецФункции

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ДинамикаЗадолженностиПоставщикам");
	НастройкиВарианта.Описание = НСтр("ru = 'Динамика задолженности поставщикам'");
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьВнешниеНаборыДанных",    Истина);
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ИспользоватьПривилегированныйРежим", Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);

	Возврат Результат;
							
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Динамика задолженности поставщикам" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	ПросроченнаяЗадолженность = Новый ТаблицаЗначений;
	ПросроченнаяЗадолженность.Колонки.Добавить("Период");
	ПросроченнаяЗадолженность.Колонки.Добавить("Организация");
	ПросроченнаяЗадолженность.Колонки.Добавить("Контрагент");
	ПросроченнаяЗадолженность.Колонки.Добавить("Договор");
	ПросроченнаяЗадолженность.Колонки.Добавить("ПросроченнаяЗадолженность");
	ПросроченнаяЗадолженность.Колонки.Добавить("ПросроченнаяЗадолженностьНачальныйОстаток");
	
	ВнешниеНаборыДанных = Новый Структура("ПросроченнаяЗадолженность", ПросроченнаяЗадолженность);
	
	Если Не ПараметрыОтчета.ПоказательПросроченнаяЗадолженность Тогда
		Возврат ВнешниеНаборыДанных;
	КонецЕсли;
	
	ТаблицаПериоды = Новый ТаблицаЗначений;
	ТаблицаПериоды.Колонки.Добавить("ПериодНачало");
	ТаблицаПериоды.Колонки.Добавить("ПериодКонец");
	
	НачалоПериода = НачалоДня(ПараметрыОтчета.НачалоПериода);
	КонецПериода  = КонецДня(?(ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода), ПараметрыОтчета.КонецПериода, Дата(3999, 1, 1)));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокОрганизаций", БухгалтерскиеОтчеты.СписокДоступныхОрганизаций(ПараметрыОтчета.Организация));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МИНИМУМ(Хозрасчетный.Период) КАК НачалоПериода,
	|	МАКСИМУМ(Хозрасчетный.Период) КАК КонецПериода
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Организация В(&СписокОрганизаций)";
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	Если Выборка.Следующий()
	   И ЗначениеЗаполнено(Выборка.НачалоПериода) Тогда
		НачалоПериода = Макс(НачалоПериода, Выборка.НачалоПериода);
		КонецПериода  = Мин(КонецПериода, Выборка.КонецПериода);
	КонецЕсли;
	
	Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ПараметрыОтчета.Периодичность, ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	КонецПериода  = БухгалтерскиеОтчетыКлиентСервер.КонецПериода(КонецПериода, Периодичность);
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода)
	   И КонецПериода < ПараметрыОтчета.КонецПериода Тогда
		КонецПериода = ПараметрыОтчета.КонецПериода;
	КонецЕсли;
	
	ТекущаяДата = НачалоПериода;
	
	Пока ТекущаяДата <= КонецПериода Цикл
		НоваяСтрока = ТаблицаПериоды.Добавить();
		Если Периодичность = 6 Тогда // День
			НоваяСтрока.ПериодНачало = НачалоДня(ТекущаяДата);
			НоваяСтрока.ПериодКонец  = КонецДня(ТекущаяДата);
			
			ТекущаяДата = ТекущаяДата + 86400;
		ИначеЕсли Периодичность = 7 Тогда // Неделя
			НоваяСтрока.ПериодНачало = НачалоНедели(ТекущаяДата);
			НоваяСтрока.ПериодКонец  = КонецНедели(ТекущаяДата);
			
			ТекущаяДата = КонецНедели(ТекущаяДата) + 86400 * 7;
		ИначеЕсли Периодичность = 9 Тогда // Месяц
			НоваяСтрока.ПериодНачало = НачалоМесяца(ТекущаяДата);
			НоваяСтрока.ПериодКонец  = КонецМесяца(ТекущаяДата);
			
			ТекущаяДата = ДобавитьМесяц(НачалоМесяца(ТекущаяДата), 1);
		ИначеЕсли Периодичность = 10 Тогда // Квартал
			НоваяСтрока.ПериодНачало = НачалоКвартала(ТекущаяДата);
			НоваяСтрока.ПериодКонец  = КонецКвартала(ТекущаяДата);
			
			ТекущаяДата = ДобавитьМесяц(НачалоКвартала(ТекущаяДата), 3);
		ИначеЕсли Периодичность = 11 Тогда // Полугодие
			Если Месяц(ТекущаяДата) > 6 Тогда
				НоваяСтрока.ПериодНачало = НачалоДня(Дата(Год(ТекущаяДата), 7, 1));
				НоваяСтрока.ПериодКонец  = КонецГода(ТекущаяДата);
			Иначе
				НоваяСтрока.ПериодНачало = НачалоДня(Дата(Год(ТекущаяДата), 1, 1));
				НоваяСтрока.ПериодКонец  = КонецМесяца(Дата(Год(ТекущаяДата), 6, 1));
			КонецЕсли;
			
			ТекущаяДата = ДобавитьМесяц(ТекущаяДата, 6);
		ИначеЕсли Периодичность = 12 Тогда // Год
			НоваяСтрока.ПериодНачало = НачалоГода(ТекущаяДата);
			НоваяСтрока.ПериодКонец  = КонецГода(ТекущаяДата);
			
			ТекущаяДата = ДобавитьМесяц(НачалоГода(ТекущаяДата), 12);
		КонецЕсли;			
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	Для Каждого Период Из ТаблицаПериоды Цикл
		
		ВременнаяТаблица = ПросроченнаяЗадолженностьПоставщикам(
							ПараметрыОтчета.Организация, Период.ПериодКонец);
		Для Каждого СтрокаТаблицы Из ВременнаяТаблица Цикл
			НоваяСтрока = ПросроченнаяЗадолженность.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			НоваяСтрока.Период = Период.ПериодНачало;
			НоваяСтрока.ПросроченнаяЗадолженностьНачальныйОстаток = НоваяСтрока.ПросроченнаяЗадолженность;
		КонецЦикла;
		
	КонецЦикла;
	УстановитьПривилегированныйРежим(Ложь);

	Возврат ВнешниеНаборыДанных;
		                                
КонецФункции

// Возвращает таблицу с просроченной задолженностью поставщикам
// Параметры:
//   Организация - СправочникСсылка.Организации - отбор по организации (может быть пустой).
//   ДатаЗадолженности - Дата - на какую дату будет получена задолженность.
//
// Возвращаемое значение:
//   ТаблицаЗначений - см. ПросроченнаяЗадолженность().
//
Функция ПросроченнаяЗадолженностьПоставщикам(Организация, ДатаЗадолженности, РазрешеноИспользоватьТекущиеИтоги = Ложь) Экспорт
	
	Возврат ПросроченнаяЗадолженность(
				2,
				Организация,
				ДатаЗадолженности,
				РазрешеноИспользоватьТекущиеИтоги);

КонецФункции

// Возвращает таблицу с просроченной задолженностью поставщикам
// Параметры:
//   Тип         - Число - определяет для кого надо получить данные: 1 - покупатель, 2 - поставщик
//   Организация - СправочникСсылка.Организации - отбор по организации (может быть пустой).
//   ДатаЗадолженности - Дата - на какую дату будет получена задолженность
//   РазрешеноИспользоватьТекущиеИтоги - Булево - Если Истина, то при совпадении даты задолженности с текущим днем, 
//				будут использованы текущие итоги регистра бухгалтерии.
//
// Возвращаемое значение:
//   ТаблицаЗначений
//     *Организация                    - СправочникСсылка.Организации
//     *Контрагент                     - СправочникСсылка.Контрагенты
//     *Договор                        - СправочникСсылка.ДоговорыКонтрагентов
//     *Документ                       - Документ расчетов с контрагентом
//     *ПросроченнаяЗадолженность      - Число
//
Функция ПросроченнаяЗадолженность(Тип, Организация, ДатаЗадолженности, РазрешеноИспользоватьТекущиеИтоги)
	
	СписокОрганизаций = БухгалтерскиеОтчеты.СписокДоступныхОрганизаций(Организация);
	
	Запрос = НовыйЗапросПросроченнаяЗадолженность(Тип, СписокОрганизаций, ДатаЗадолженности, РазрешеноИспользоватьТекущиеИтоги);
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ПросроченнаяЗадолженность = РезультатЗапроса[3].Выгрузить(); // учтены сроки оплаты документов
	
	СрокиОплаты = РезультатЗапроса[4].Выгрузить().ВыгрузитьКолонку("СрокОплаты"); // сроки оплаты долгов без документов
	
	// Не для всех задолженностей можно определить документ расчетов, и, как следствие - дату возникновения долга.
	// Поэтому для долгов без документов используется следующая методика:
	// Получаем сумму долга на дату задолженности, из этой суммы вычитаем сумму увеличения долга за период отсрочки.
	// Например, долг, который был вчера, это долг, который есть сегодня, минус увеличение долга за этот один день.
	// Таким образом, получаем сумму просроченной задолженностью.
	Если СрокиОплаты.Количество() > 0 Тогда
		
		ДлинаСуток = 86400;
		ТекстЗапросаУвеличениеДолга = "";
		
		Для Индекс = 0 По СрокиОплаты.ВГраница() Цикл
			
			СрокОплаты             = СрокиОплаты[Индекс];
			ДатаНачалаИнтервала    = НачалоДня(ДатаЗадолженности - ДлинаСуток * СрокОплаты);
			ГраницаНачалаИнтервала = Новый Граница(ДатаНачалаИнтервала, ВидГраницы.Включая);
			
			Запрос.УстановитьПараметр("НачалоИнтервала" + (Индекс+1), ГраницаНачалаИнтервала);
			Запрос.УстановитьПараметр("СрокОплаты"      + (Индекс+1), СрокОплаты);
			
			Если НЕ ПустаяСтрока(ТекстЗапросаУвеличениеДолга) Тогда
				ТекстЗапросаУвеличениеДолга = ТекстЗапросаУвеличениеДолга + Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
			КонецЕсли;
			
			ТекстЗапросаУвеличениеДолга = ТекстЗапросаУвеличениеДолга + ТекстЗапросаУвеличениеДолгаЗаПериодСрока(Тип, Индекс+1);
			
		КонецЦикла;
		
		Запрос.Текст = ТекстЗапросаУвеличениеДолга + ОбщегоНазначения.РазделительПакетаЗапросов()
					 + ТекстЗапросаПодсчетПросроченногоДолгаБезДокументов();
		
		ОстальнаяПросроченнаяЗадолженность = Запрос.Выполнить().Выгрузить();
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ОстальнаяПросроченнаяЗадолженность, ПросроченнаяЗадолженность);
		
	КонецЕсли;
	
	Возврат ПросроченнаяЗадолженность;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйЗапросПросроченнаяЗадолженность(Тип, СписокОрганизаций, ДатаЗадолженности, РазрешеноИспользоватьТекущиеИтоги)
	
	Если Тип = 1 Тогда
		
		ВидыДоговоров            = БухгалтерскиеОтчеты.ВидыДоговоровПокупателей();
		СчетаУчетаРасчетов       = МониторРуководителя.СчетаРасчетовСКонтрагентами(1);
		СрокОплатыПараметрыУчета = Константы.СрокОплатыПокупателей.Получить();
		ИспользуютсяСрокиОплаты  = ЗначениеЗаполнено(СрокОплатыПараметрыУчета);
		
	ИначеЕсли Тип = 2 Тогда
		
		ВидыДоговоров            = БухгалтерскиеОтчеты.ВидыДоговоровПоставщиков();
		СчетаУчетаРасчетов       = МониторРуководителя.СчетаРасчетовСКонтрагентами(2);
		СрокОплатыПараметрыУчета = Константы.СрокОплатыПоставщикам.Получить();
		ИспользуютсяСрокиОплаты  = ЗначениеЗаполнено(СрокОплатыПараметрыУчета);
		
	КонецЕсли;
	
	ВидСубконтоКонтрагенты = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты;
	ВидСубконтоДоговоры    = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры;
	
	ВидыСубконтоКД = Новый СписокЗначений;
	ВидыСубконтоКД.Добавить(ВидСубконтоКонтрагенты);
	ВидыСубконтоКД.Добавить(ВидСубконтоДоговоры);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("СписокОрганизаций", СписокОрганизаций);
	Запрос.УстановитьПараметр("ВидыДоговоров", ВидыДоговоров);
	Запрос.УстановитьПараметр("КонецИнтервала", КонецДня(ДатаЗадолженности));
	Запрос.УстановитьПараметр("ВидыСубконтоКД", ВидыСубконтоКД);
	Если РазрешеноИспользоватьТекущиеИтоги И КонецДня(ДатаЗадолженности) = КонецДня(ТекущаяДатаСеанса()) Тогда
		// Если остатки получаются "на сегодня", то обращаемся к текущим итогам регистра.
		Запрос.УстановитьПараметр("ГраницаОстатков", Неопределено);
	Иначе
		Запрос.УстановитьПараметр("ГраницаОстатков", Новый Граница(КонецДня(ДатаЗадолженности), ВидГраницы.Включая));
	КонецЕсли;
	Запрос.УстановитьПараметр("ДатаЗадолженности", НачалоДня(ДатаЗадолженности));
	Запрос.УстановитьПараметр("СтандартныйСрокОплаты", СрокОплатыПараметрыУчета);
	Запрос.УстановитьПараметр("СчетаБезДокументаРасчетов", СчетаУчетаРасчетов);
	Запрос.УстановитьПараметр("СчетаСДокументомРасчетов", Новый СписокЗначений);
	Запрос.УстановитьПараметр("ИспользуютсяСрокиОплаты", ИспользуютсяСрокиОплаты);
	
	Запрос.Текст = ТекстЗапросаДолгиПоДокументамИСрокиДолговБезДокументов(Тип);
	
	Возврат Запрос;
	
КонецФункции

Функция ТекстЗапросаДолгиПоДокументамИСрокиДолговБезДокументов(Тип)
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВзаиморасчетыОстатки.Организация КАК Организация,
		|	ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто1 КАК Справочник.Контрагенты) КАК Контрагент,
		|	ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов) КАК Договор,
		|	&СтандартныйСрокОплаты КАК СрокОплаты,
		|	НЕОПРЕДЕЛЕНО КАК Документ,
		|	ВзаиморасчетыОстатки.СуммаРазвернутыйОстатокДт КАК ОстатокДолга
		|ПОМЕСТИТЬ ОстаткиДолгаПоДокументам
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&ГраницаОстатков,
		|			Счет В (&СчетаСДокументомРасчетов),
		|			,
		|			ЛОЖЬ
		|				И ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (&ВидыДоговоров)
		|				И Организация В (&СписокОрганизаций)) КАК ВзаиморасчетыОстатки
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Контрагент,
		|	Договор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВзаиморасчетыОстатки.Организация КАК Организация,
		|	ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто1 КАК Справочник.Контрагенты) КАК Контрагент,
		|	ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов) КАК Договор,
		|	&СтандартныйСрокОплаты КАК СрокОплаты,
		|	ВзаиморасчетыОстатки.СуммаРазвернутыйОстатокДт КАК ОстатокДолга
		|ПОМЕСТИТЬ ОстаткиДолгаБезДокументовБезГруппировки
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&ГраницаОстатков,
		|			Счет В (&СчетаБезДокументаРасчетов),
		|			&ВидыСубконтоКД,
		|			ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (&ВидыДоговоров)
		|				И Организация В (&СписокОрганизаций)) КАК ВзаиморасчетыОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиДолгаБезДокументовБезГруппировки.Организация КАК Организация,
		|	ОстаткиДолгаБезДокументовБезГруппировки.Контрагент КАК Контрагент,
		|	ОстаткиДолгаБезДокументовБезГруппировки.Договор КАК Договор,
		|	ОстаткиДолгаБезДокументовБезГруппировки.СрокОплаты КАК СрокОплаты,
		|	СУММА(ОстаткиДолгаБезДокументовБезГруппировки.ОстатокДолга) КАК ОстатокДолга
		|ПОМЕСТИТЬ ОстаткиДолгаБезДокументов
		|ИЗ
		|	ОстаткиДолгаБезДокументовБезГруппировки КАК ОстаткиДолгаБезДокументовБезГруппировки
		|
		|СГРУППИРОВАТЬ ПО
		|	ОстаткиДолгаБезДокументовБезГруппировки.Договор,
		|	ОстаткиДолгаБезДокументовБезГруппировки.Организация,
		|	ОстаткиДолгаБезДокументовБезГруппировки.Контрагент,
		|	ОстаткиДолгаБезДокументовБезГруппировки.СрокОплаты
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Организация,
		|	Контрагент,
		|	Договор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиДолгаПоДокументам.Организация КАК Организация,
		|	ОстаткиДолгаПоДокументам.Контрагент КАК Контрагент,
		|	ОстаткиДолгаПоДокументам.Договор КАК Договор,
		|	ОстаткиДолгаПоДокументам.Документ КАК Документ,
		|	ОстаткиДолгаПоДокументам.ОстатокДолга КАК ПросроченнаяЗадолженность
		|ИЗ
		|	ОстаткиДолгаПоДокументам КАК ОстаткиДолгаПоДокументам
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
		|		ПО ОстаткиДолгаПоДокументам.Организация = ДанныеПервичныхДокументов.Организация
		|			И ОстаткиДолгаПоДокументам.Документ = ДанныеПервичныхДокументов.Документ
		|ГДЕ
		|	ОстаткиДолгаПоДокументам.Документ <> НЕОПРЕДЕЛЕНО
		|	И ДОБАВИТЬКДАТЕ(ДанныеПервичныхДокументов.ДатаРегистратора, ДЕНЬ, ОстаткиДолгаПоДокументам.СрокОплаты) < &ДатаЗадолженности
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ОстаткиДолгаБезДокументов.СрокОплаты КАК СрокОплаты
		|ИЗ
		|	ОстаткиДолгаБезДокументов КАК ОстаткиДолгаБезДокументов";
	
	Если Тип = 2 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СуммаРазвернутыйОстатокДт", "СуммаРазвернутыйОстатокКт");
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаУвеличениеДолгаЗаПериодСрока(Тип, Индекс)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВзаиморасчетыОбороты.Организация КАК Организация,
	|	ВзаиморасчетыОбороты.Субконто1 КАК Контрагент,
	|	ВзаиморасчетыОбороты.Субконто2 КАК Договор,
	|	&ПолеУвеличениеДолга КАК УвеличениеДолга"
	+
	?(Индекс = 1, Символы.ПС + "ПОМЕСТИТЬ УвеличениеДолгаБезГруппировки" + Символы.ПС, Символы.ПС)
	+
	"ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			&НачалоИнтервала0,
	|			&ГраницаОстатков,
	|			,
	|			Счет В (&СчетаБезДокументаРасчетов),
	|			&ВидыСубконтоКД,
	|			&СтандартныйСрокОплаты = &СрокОплаты0
	|				И Организация В(&СписокОрганизаций),
	|			,
	|			) КАК ВзаиморасчетыОбороты";
	
	Если Тип = 1 Тогда
		ТекстПоляУвеличениеДолга = 
		"ВЫБОР
		|	КОГДА ВзаиморасчетыОбороты.СуммаОборотДт > 0
		|		ТОГДА ВзаиморасчетыОбороты.СуммаОборотДт
		|	ИНАЧЕ 0
		|КОНЕЦ - ВЫБОР
		|	КОГДА ВзаиморасчетыОбороты.СуммаОборотДт < 0
		|		ТОГДА ВзаиморасчетыОбороты.СуммаОборотДт
		|	ИНАЧЕ 0
		|КОНЕЦ";
	ИначеЕсли Тип = 2 Тогда
		ТекстПоляУвеличениеДолга = 
		"ВЫБОР
		|	КОГДА ВзаиморасчетыОбороты.СуммаОборотКт > 0
		|		ТОГДА ВзаиморасчетыОбороты.СуммаОборотКт
		|	ИНАЧЕ 0
		|КОНЕЦ - ВЫБОР
		|	КОГДА ВзаиморасчетыОбороты.СуммаОборотДт < 0
		|		ТОГДА ВзаиморасчетыОбороты.СуммаОборотДт
		|	ИНАЧЕ 0
		|КОНЕЦ";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеУвеличениеДолга", ТекстПоляУвеличениеДолга);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "НачалоИнтервала0"    , "НачалоИнтервала" + Индекс);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СрокОплаты0"         , "СрокОплаты"      + Индекс);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаПодсчетПросроченногоДолгаБезДокументов()
	
	Возврат
	"ВЫБРАТЬ
	|	УвеличениеДолгаБезГруппировки.Организация КАК Организация,
	|	УвеличениеДолгаБезГруппировки.Контрагент КАК Контрагент,
	|	УвеличениеДолгаБезГруппировки.Договор КАК Договор,
	|	СУММА(УвеличениеДолгаБезГруппировки.УвеличениеДолга) КАК УвеличениеДолга
	|ПОМЕСТИТЬ УвеличениеДолгаДляВсехСроков
	|ИЗ
	|	УвеличениеДолгаБезГруппировки КАК УвеличениеДолгаБезГруппировки
	|
	|СГРУППИРОВАТЬ ПО
	|	УвеличениеДолгаБезГруппировки.Договор,
	|	УвеличениеДолгаБезГруппировки.Организация,
	|	УвеличениеДолгаБезГруппировки.Контрагент
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Контрагент,
	|	Договор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиДолгаБезДокументов.Организация,
	|	ОстаткиДолгаБезДокументов.Контрагент,
	|	ОстаткиДолгаБезДокументов.Договор,
	|	ВЫБОР
	|		КОГДА ОстаткиДолгаБезДокументов.ОстатокДолга > ЕСТЬNULL(УвеличениеДолгаДляВсехСроков.УвеличениеДолга, 0)
	|			ТОГДА ОстаткиДолгаБезДокументов.ОстатокДолга - ЕСТЬNULL(УвеличениеДолгаДляВсехСроков.УвеличениеДолга, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ПросроченнаяЗадолженность
	|ИЗ
	|	ОстаткиДолгаБезДокументов КАК ОстаткиДолгаБезДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ УвеличениеДолгаДляВсехСроков КАК УвеличениеДолгаДляВсехСроков
	|		ПО ОстаткиДолгаБезДокументов.Организация = УвеличениеДолгаДляВсехСроков.Организация
	|			И ОстаткиДолгаБезДокументов.Контрагент = УвеличениеДолгаДляВсехСроков.Контрагент
	|			И ОстаткиДолгаБезДокументов.Договор = УвеличениеДолгаДляВсехСроков.Договор";
	
КонецФункции

#КонецОбласти

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	СчетаУчетаРасчетов = МониторРуководителя.СчетаРасчетовСКонтрагентами(2);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаРасчетовСКонтрагентами", СчетаУчетаРасчетов);
	
	ВидыСубконтоКД = Новый СписокЗначений;
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидыСубконтоКД", ВидыСубконтоКД);
	
	ИсключенныеСчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьСписокСчетовИсключаемыхИзРасчетаЗадолженности(2);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ИсключенныеСчета", ИсключенныеСчета);
	
	Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ПараметрыОтчета.Периодичность, ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Периодичность);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		НачалоПериода = БухгалтерскиеОтчетыКлиентСервер.НачалоПериода(ПараметрыОтчета.НачалоПериода, Периодичность);
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоПериода);
		ПараметрыОтчета.НачалоПериода = НачалоПериода;
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		КонецПериода = БухгалтерскиеОтчетыКлиентСервер.КонецПериода(ПараметрыОтчета.КонецПериода, Периодичность);
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецПериода);
		ПараметрыОтчета.КонецПериода = КонецПериода;
	КонецЕсли;
	
	ВыводитьДиаграмму = Неопределено;
	
	Если НЕ ПараметрыОтчета.Свойство("ВыводитьДиаграмму", ВыводитьДиаграмму) Тогда
		
		ВыводитьДиаграмму = Истина;
		
	КонецЕсли;
	
	Период   = Неопределено;
	Диаграмма = Неопределено;
	Для Каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл		
		Если ЭлементСтруктуры.Имя = "Период" Тогда
			Период = ЭлементСтруктуры;
		ИначеЕсли ЭлементСтруктуры.Имя = "Диаграмма" Тогда
			Диаграмма = ЭлементСтруктуры;
		КонецЕсли;		
	КонецЦикла;
	
	Если Диаграмма <> Неопределено Тогда
		
		Если ВыводитьДиаграмму Тогда
			
			Диаграмма.Точки.Очистить();
			ГруппировкаПериод = Диаграмма.Точки.Добавить();
			ПолеГруппировки = ГруппировкаПериод.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование = Истина;
			ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("Период");
			ПолеГруппировки.ТипДополнения = БухгалтерскиеОтчетыВызовСервера.ПолучитьТипДополненияПоИнтервалу(Периодичность);
			ПолеГруппировки.НачалоПериода =	НачалоДня(ПараметрыОтчета.НачалоПериода);
			ПолеГруппировки.КонецПериода  = КонецДня(ПараметрыОтчета.КонецПериода);
			
			ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			ГруппировкаПериод.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
		Иначе
			
			Диаграмма.Использование = ВыводитьДиаграмму;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Период <> Неопределено Тогда
		Период.ПоляГруппировки.Элементы.Очистить();
		ПолеГруппировки = Период.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование = Истина;
		ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("Период");
		ПолеГруппировки.ТипДополнения = БухгалтерскиеОтчетыВызовСервера.ПолучитьТипДополненияПоИнтервалу(Периодичность);
		ПолеГруппировки.НачалоПериода = НачалоДня(ПараметрыОтчета.НачалоПериода);
		ПолеГруппировки.КонецПериода  = КонецДня(ПараметрыОтчета.КонецПериода);
		
		Период.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		Период.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	КонецЕсли;
	
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	Если ПараметрыОтчета.ПоказательЗадолженность Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, "Задолженность");
	КонецЕсли;
	Если ПараметрыОтчета.ПоказательПросроченнаяЗадолженность Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, "ПросроченнаяЗадолженность");
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	ВывестиПримечания(ПараметрыОтчета, Результат);	
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Для Каждого Вариант из Схема.ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;	
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
		
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ПользовательскиеОтборы = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ПользовательскиеОтборы.ИдентификаторПользовательскойНастройки = "Отбор";
	
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(Адрес);
	
	ОтчетОбъект       = ДанныеОбъекта.Объект;
	ДанныеРасшифровки = ДанныеОбъекта.ДанныеРасшифровки;
   	
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("Организация", ОтчетОбъект.Организация);
	ДополнительныеСвойства.Вставить("РежимРасшифровки", Истина);
		
	Раздел        = Неопределено;
	Период        = Неопределено;
	Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ОтчетОбъект.Периодичность, ОтчетОбъект.НачалоПериода, ОтчетОбъект.КонецПериода);
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(ДанныеРасшифровки.Настройки);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ДанныеОбъекта.Объект.СхемаКомпоновкиДанных));
	
	МассивПолей = БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки(Расшифровка, ДанныеРасшифровки, КомпоновщикНастроек, Истина);

 	Для Каждого Отбор Из МассивПолей Цикл
		Если ТипЗнч(Отбор) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") тогда
			Если Отбор.Значение = NULL тогда
				Продолжить;
			КонецЕсли;
			
			Если Отбор.Поле = "Организация" Тогда
				ДополнительныеСвойства.Вставить("Организация", Отбор.Значение);
			ИначеЕсли Отбор.Поле = "Период" Тогда
				Период = Отбор.Значение;
			ИначеЕсли  Отбор.Поле = "Раздел" Тогда
				Раздел = Отбор.Значение;
			Иначе
				Если Отбор.Иерархия Тогда
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение, ВидСравненияКомпоновкиДанных.ВИерархии);
				Иначе
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение);
				КонецЕсли;
			КонецЕсли;	
		ИначеЕсли ТипЗнч(Отбор) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Если Отбор.Представление = "###ОтборПоОрганизацииСОП###" Тогда
				Для Каждого ЭлементОтбора Из Отбор.Элементы Цикл
					Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") Тогда
						ДополнительныеСвойства.Вставить("Организация", ЭлементОтбора.ПравоеЗначение);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		ИначеЕсли ТипЗнч(Отбор) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Если Отбор.Представление = "###ОтборПоОрганизации###" Тогда
				ДополнительныеСвойства.Вставить("Организация", Отбор.ПравоеЗначение);
			Иначе
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.ЛевоеЗначение, Отбор.ПравоеЗначение, Отбор.ВидСравнения);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
 	Если Период <> Неопределено Тогда
		ДополнительныеСвойства.Вставить("Период", БухгалтерскиеОтчетыКлиентСервер.КонецПериода(Период, Периодичность));
	Иначе
		ДополнительныеСвойства.Вставить("Период", ОтчетОбъект.КонецПериода);
	КонецЕсли;
	ДополнительныеСвойства.Вставить("КлючВарианта", "ЗадолженностьПоставщикамПоСрокамДолга");
	
	СписокПунктовМеню = Новый СписокЗначений;
	СписокПунктовМеню.Добавить("ЗадолженностьПоставщикамПоСрокамДолга", "Задолженность поставщикам по срокам долга");
	
	НастройкиРасшифровки = Новый Структура("ЗадолженностьПоставщикамПоСрокамДолга", ПользовательскиеНастройки);
	
	ДанныеОбъекта.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	
	Адрес = ПоместитьВоВременноеХранилище(ДанныеОбъекта, Адрес);
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("Задолженность");
	НаборПоказателей.Добавить("ПросроченнаяЗадолженность");

	Возврат НаборПоказателей;
	
КонецФункции

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	Для Каждого Показатель Из ПолучитьНаборПоказателей() Цикл
		КоллекцияНастроек.Вставить("Показатель" + Показатель, Ложь);
	КонецЦикла;
	КоллекцияНастроек.Вставить("Организация"                      , Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("Периодичность"                    , 0);
	КоллекцияНастроек.Вставить("ВыводитьДиаграмму"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПримечания"               , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодвал"                   , Ложь);
	КоллекцияНастроек.Вставить("МакетОформления"                  , Неопределено);
	КоллекцияНастроек.Вставить("НастройкиКомпоновкиДанных"        , Неопределено);
	
	Возврат КоллекцияНастроек;
	
КонецФункции

// Возвращает структуру параметров, наличие которых требуется для успешного формирования отчета.
//
// Возвращаемое значение:
//   Структура - структура параметров для формирования отчета.
//
Функция ПустыеПараметрыКомпоновкиОтчета() Экспорт
	
	// Часть параметров компоновки отчета используется так же и в рассылке отчета.
	ПараметрыОтчета = НастройкиОтчетаСохраняемыеВРассылке();
	
	// Дополним параметрами, влияющими на формирование отчета.
	ПараметрыОтчета.Вставить("ПериодОтчета"         , Неопределено);
	ПараметрыОтчета.Вставить("НачалоПериода"        , Дата(1,1,1));
	ПараметрыОтчета.Вставить("КонецПериода"         , Дата(1,1,1));
	ПараметрыОтчета.Вставить("РежимРасшифровки"     , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"    , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных", Неопределено);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"  , "");
	
	Возврат ПараметрыОтчета;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ВывестиПримечания(ПараметрыОтчета, Результат)
	
	Если НЕ ПараметрыОтчета.ВыводитьПримечания Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыОтчета.ВыводитьПодвал Тогда
		ОбластьПодписи = Результат.Области.Найти("Подписи");
		ЗавершениеТаблицы = ОбластьПодписи.Верх;
	Иначе
		ЗавершениеТаблицы = Результат.ВысотаТаблицы;
	КонецЕсли;
	
	СрокОплаты = Константы.СрокОплатыПоставщикам.Получить();
	
	Примечания = ПолучитьМакет("Примечания");
	Примечания.Параметры.СрокОплаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 дн.'"), СрокОплаты);
	Примечания.Параметры.Ссылка = "e1cib/command/ОбщаяКоманда.СрокОплатыПоставщикам";
	
	Примечание = Примечания.Область(?(СрокОплаты = 0, "СрокОплатыНеУстановлен", "УстановленСрокОплаты"));
		
	Результат.ВставитьОбласть(Примечание, Результат.Область("R" + Строка(ЗавершениеТаблицы)),, Истина);
	
КонецПроцедуры

#КонецЕсли