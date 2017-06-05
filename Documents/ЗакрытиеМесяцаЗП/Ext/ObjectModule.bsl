﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	// Проверка повторного закрытия месяца
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЗакрытиеМесяцаЗП.Ссылка
		|ИЗ
		|	Документ.ЗакрытиеМесяцаЗП КАК ЗакрытиеМесяцаЗП
		|ГДЕ
		|	ЗакрытиеМесяцаЗП.Организация = &Организация
		|	И ЗакрытиеМесяцаЗП.Дата = &Дата
		|	И ЗакрытиеМесяцаЗП.Проведен
		|	И ЗакрытиеМесяцаЗП.Ссылка <> &Ссылка";
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда 
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Документ закрытия месяца по заработной плате за выбранный период уже существует: %1.'"), 
			ВыборкаДетальныеЗаписи.Ссылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;
	
	ДанныеУчетнойПолитики = БухгалтерскийУчетСервер.ПолучитьДанныеУчетнойПолитикиПоПерсоналу(Дата, Организация);
	
	// Проверка заполнения данных учетной политики.
	Если НЕ ЗначениеЗаполнено(ДанныеУчетнойПолитики.СчетУчета) Тогда 
		ТекстСообщения = НСтр("ru = 'В учетной политике по персоналу не заполнен счет учета для отражения начисленной заработной платы.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(ДанныеУчетнойПолитики.СчетУчетаРасходовПоДоплатеПН) Тогда 
		ТекстСообщения = НСтр("ru = 'В учетной политике по персоналу не заполнен счет учета расходов по доплате ПН.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(ДанныеУчетнойПолитики.СчетУчетаРасходовПоКорректировкеСФ) Тогда 
		ТекстСообщения = НСтр("ru = 'В учетной политике по персоналу не заполнен счет учета расходов по корректировке СФ.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;	

	Если НЕ ЗначениеЗаполнено(ДанныеУчетнойПолитики.СчетУчетаРасчетовПФР) Тогда 
		ТекстСообщения = НСтр("ru = 'В учетной политике по персоналу не заполнен счет учета расчетов ПФР.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(ДанныеУчетнойПолитики.СчетУчетаРасчетовГНПФР) Тогда 
		ТекстСообщения = НСтр("ru = 'В учетной политике по персоналу не заполнен счет учета расчетов ГНПФР.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;	

	Если НЕ ЗначениеЗаполнено(ДанныеУчетнойПолитики.СчетУчетаРасчетовМСФ) Тогда 
		ТекстСообщения = НСтр("ru = 'В учетной политике по персоналу не заполнен счет учета расчетов МСФ.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;	

	Если НЕ ЗначениеЗаполнено(ДанныеУчетнойПолитики.СчетУчетаРасчетовПФФ) Тогда 
		ТекстСообщения = НСтр("ru = 'В учетной политике по персоналу не заполнен счет учета расчетов ПФФ.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;	

	Если НЕ ЗначениеЗаполнено(ДанныеУчетнойПолитики.СчетУчетаРасчетовФОТФ) Тогда 
		ТекстСообщения = НСтр("ru = 'В учетной политике по персоналу не заполнен счет учета расчетов ФОТФ.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;	

	Если НЕ ЗначениеЗаполнено(ДанныеУчетнойПолитики.СчетУчетаРасчетовПрофВзнос) Тогда 
		ТекстСообщения = НСтр("ru = 'В учетной политике по персоналу не заполнен счет учета расчетов ПрофВзнос.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЕсли;	

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Начисления.ФизЛицо,
		|	Начисления.ВидРасчета,
		|	Начисления.СчетУчетаЗатрат,
		|	Начисления.СтатьяЗатрат
		|ИЗ
		|	РегистрРасчета.Начисления КАК Начисления
		|ГДЕ
		|	Начисления.ПериодРегистрации МЕЖДУ &НачалоПериода И &КонецПериода
		|	И Начисления.Организация = &Организация
		|	И НЕ Начисления.Результат = 0
		|	И (Начисления.СчетУчетаЗатрат = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)
		|			ИЛИ Начисления.СтатьяЗатрат = ЗНАЧЕНИЕ(Справочник.СтатьиЗатратИДоходов.ПустаяСсылка))
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	""Виды удержаний"",
		|	ВидыУдержаний.Ссылка,
		|	ВидыУдержаний.СчетУчета,
		|	""Без проверки""
		|ИЗ
		|	ПланВидовРасчета.ВидыУдержаний КАК ВидыУдержаний";
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если НЕ ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.СчетУчетаЗатрат) Тогда 	
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнен счет учета (затраты) Сотрудник: %1 вид расчета: %2.'"), 
				ВыборкаДетальныеЗаписи.ФизЛицо, ВыборкаДетальныеЗаписи.ВидРасчета);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.СтатьяЗатрат) Тогда 	
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнена статья затрат Сотрудник: %1 вид расчета: %2.'"), 
				ВыборкаДетальныеЗаписи.ФизЛицо, ВыборкаДетальныеЗаписи.ВидРасчета);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

Процедура ОтразитьОтчетПоПодоходному(ДополнительныеСвойства, Движения, Отказ)
	
	ТаблицаДляЗагрузки = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаОтчетПоПодоходномуНалогу;
	
	Если Отказ
		ИЛИ ТаблицаДляЗагрузки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияПоРегистру = Движения.ДанныеОтчетаПоПН;
	ДвиженияПоРегистру.Записывать = Истина;
	ДвиженияПоРегистру.Загрузить(ТаблицаДляЗагрузки);
КонецПроцедуры

Процедура ОтразитьОтчетЕжемесячныйСоцфонд(ДополнительныеСвойства, Движения, Отказ)
	
	ТаблицаДляЗагрузки = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДанныеДляОтчетаПоЕжемесячномуСФ;
	
	Если Отказ
		ИЛИ ТаблицаДляЗагрузки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияПоРегистру = Движения.ДанныеДляОтчетаПоСФЕжемесячному;
	ДвиженияПоРегистру.Записывать = Истина;
	ДвиженияПоРегистру.Загрузить(ТаблицаДляЗагрузки);
КонецПроцедуры

Процедура ОтразитьОтчетКвартальныйСоцфонд(ДополнительныеСвойства, Движения, Отказ)
	
	ТаблицаДляЗагрузки = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДанныеДляОтчетаПоКвартальномуСФ;
	
	Если Отказ
		ИЛИ ТаблицаДляЗагрузки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияПоРегистру = Движения.ДанныеДляОтчетаПоСФКвартальному;
	ДвиженияПоРегистру.Записывать = Истина;
	ДвиженияПоРегистру.Загрузить(ТаблицаДляЗагрузки);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектов.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Дата = КонецМесяца(ТекущаяДата());
	КонецЕсли;
		
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ЗакрытиеМесяцаЗП.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, ЭтотОбъект);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьУдержания(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьВзаиморасчетыССотрудниками(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьПодоходныйНалог(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьСоциальныйФонд(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьНалогиПоЗаработнойПлате(ДополнительныеСвойства, Движения, Отказ);

	// отражение в регистрах для отчетов по налогам по ЗП
	ОтразитьОтчетПоПодоходному(ДополнительныеСвойства, Движения, Отказ);
	ОтразитьОтчетЕжемесячныйСоцфонд(ДополнительныеСвойства, Движения, Отказ);
	ОтразитьОтчетКвартальныйСоцфонд(ДополнительныеСвойства, Движения, Отказ);

	БухгалтерскийУчетСервер.ОтразитьХозрасчетный(ДополнительныеСвойства, Движения, Отказ);
	
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

// В обработчике события ОбработкаПроверкиЗаполнения документа выполняется
// копирование и обнуление проверяемых реквизитов для исключения стандартной
// проверки заполнения платформой и последующей проверки средствами встроенного языка.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#КонецЕсли
