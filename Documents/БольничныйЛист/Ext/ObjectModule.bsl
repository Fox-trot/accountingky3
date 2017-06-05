﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет табличную часть
//
Процедура ЗаполнитьТабличнуюЧасть() Экспорт 
	// Определение количества месяцев
	ВидРасчета = МетодРасчета.ВидРасчетаСФ; 
	КоличествоМесяцев = ВидРасчета.ПериодРасчетаСреднегоЗаработка;
	Если КоличествоМесяцев = 0 Тогда 
		КоличествоМесяцев = 3;
	КонецЕсли;	
	
	НеполныеМесяцы = МетодРасчета.НеполныеМесяцы;
	
	Если НеполныеМесяцы = ПредопределенноеЗначение("Перечисление.НеполныеМесяцы.Отбрасывать") Тогда 
		БазовыйПериодНачало = ДобавитьМесяц(НачалоМесяца(ДатаНачала), - 12);
		БазовыйПериодКонец = НачалоМесяца(ДатаНачала) - 1;
	Иначе 
		БазовыйПериодНачало = ДобавитьМесяц(НачалоМесяца(ДатаНачала), -КоличествоМесяцев);
		БазовыйПериодКонец = НачалоМесяца(ДатаНачала) - 1;
	КонецЕсли;	
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(ТаблицаДокумента.Дата, МЕСЯЦ) КАК ПериодРегистрации,
		|	НАЧАЛОПЕРИОДА(ТаблицаДокумента.ДатаНачала, МЕСЯЦ) КАК ПериодДействияНачало,
		|	КОНЕЦПЕРИОДА(ТаблицаДокумента.ДатаНачала, МЕСЯЦ) КАК ПериодДействияКонец,
		|	&БазовыйПериодНачало,
		|	&БазовыйПериодКонец,
		|	&ВидРасчета,
		|	ТаблицаДокумента.ФизЛицо,
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.ГрафикРаботы,
		|	ТаблицаДокумента.Подразделение,
		|	ТаблицаДокумента.Должность
		|ИЗ
		|	Документ.БольничныйЛист КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Период", ДатаОкончания);	
	Запрос.УстановитьПараметр("Организация", Организация);	
	Запрос.УстановитьПараметр("ВидРасчета", ВидРасчета);	
	Запрос.УстановитьПараметр("БазовыйПериодНачало", БазовыйПериодНачало);	
	Запрос.УстановитьПараметр("БазовыйПериодКонец", БазовыйПериодКонец);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаНачисления", РезультатЗапроса.Выгрузить());
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьНачисления(ДополнительныеСвойства, Движения, Ложь);

	// Запись наборов записей.
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
	Запрос = Новый Запрос();
	
	Измерения = Новый Массив(2);
	Измерения[0] = "Физлицо";
	Измерения[1] = "Организация";
	
	Разрезы = Новый Массив(2);
	Разрезы[0] = "ПериодРегистрации";
	Разрезы[1] = "ВидРасчета";
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаФакт.ФизЛицо,
		|	ТаблицаФакт.Результат,
		|	ТаблицаФакт.ОтработаноДней,
		|	ТаблицаФакт.ПериодРегистрации КАК ПериодРегистрации,
		|	ТаблицаНорма.НормаДней
		|ИЗ
		|	(ВЫБРАТЬ
		|		Начисления.ФизЛицо КАК ФизЛицо,
		|		СУММА(ВЫБОР
		|				КОГДА НачисленияБазаНачисления.ВидРасчетаРазрез.СпособРасчета = ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаНачислений.ГодоваяПремия)
		|					ТОГДА НачисленияБазаНачисления.РезультатБаза / НачисленияБазаНачисления.ВидРасчетаРазрез.Доля
		|				ИНАЧЕ НачисленияБазаНачисления.РезультатБаза
		|			КОНЕЦ) КАК Результат,
		|		СУММА(ВЫБОР
		|				КОГДА НачисленияБазаНачисления.ВидРасчетаРазрез.ЗачетОтработанногоВремени
		|					ТОГДА НачисленияБазаНачисления.ОтработаноДнейБаза
		|				ИНАЧЕ 0
		|			КОНЕЦ) КАК ОтработаноДней,
		|		НачисленияБазаНачисления.ПериодРегистрацииРазрез КАК ПериодРегистрации
		|	ИЗ
		|		РегистрРасчета.Начисления КАК Начисления
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрРасчета.Начисления.БазаНачисления(
		|					&ИзмеренияОсновного,
		|					&ИзмеренияБазового,
		|					&Разрезы,
		|					Регистратор = &Регистратор
		|						И &Организация = Организация
		|						И &ФизЛицо = ФизЛицо) КАК НачисленияБазаНачисления
		|			ПО Начисления.НомерСтроки = НачисленияБазаНачисления.НомерСтроки
		|	ГДЕ
		|		Начисления.Регистратор = &Регистратор
		|	
		|	СГРУППИРОВАТЬ ПО
		|		Начисления.ФизЛицо,
		|		НачисленияБазаНачисления.ПериодРегистрацииРазрез) КАК ТаблицаФакт
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ДанныеПроизводственногоКалендаря.ГрафикРаботы КАК ГрафикРаботы,
		|			НАЧАЛОПЕРИОДА(ДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ) КАК ПериодРегистрации,
		|			СУММА(ДанныеПроизводственногоКалендаря.ЗначениеДней) КАК НормаДней
		|		ИЗ
		|			РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|		ГДЕ
		|			ДанныеПроизводственногоКалендаря.ГрафикРаботы = &ГрафикРаботы
		|			И (ДанныеПроизводственногоКалендаря.Год = &ГодБазовыйПериодНачало
		|					ИЛИ ДанныеПроизводственногоКалендаря.Год = &ГодБазовыйПериодКонец)
		|			И ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &БазовыйПериодНачало И &БазовыйПериодКонец
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ДанныеПроизводственногоКалендаря.ГрафикРаботы,
		|			НАЧАЛОПЕРИОДА(ДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ)) КАК ТаблицаНорма
		|		ПО ТаблицаФакт.ПериодРегистрации = ТаблицаНорма.ПериодРегистрации
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПериодРегистрации УБЫВ";
	// Для факт	
	Запрос.УстановитьПараметр("ИзмеренияБазового",  	Измерения);
	Запрос.УстановитьПараметр("ИзмеренияОсновного",  	Измерения);
	Запрос.УстановитьПараметр("Разрезы",  				Разрезы);
	Запрос.УстановитьПараметр("Регистратор",  			Ссылка);
	Запрос.УстановитьПараметр("Организация",  			Организация);
	Запрос.УстановитьПараметр("ФизЛицо",  				ФизЛицо);
	// Для норма
	Запрос.УстановитьПараметр("ГрафикРаботы",  			ГрафикРаботы);
	Запрос.УстановитьПараметр("ГодБазовыйПериодНачало",	Год(БазовыйПериодНачало));
	Запрос.УстановитьПараметр("ГодБазовыйПериодКонец", 	Год(БазовыйПериодКонец));
	Запрос.УстановитьПараметр("БазовыйПериодНачало",	БазовыйПериодНачало);	
	Запрос.УстановитьПараметр("БазовыйПериодКонец", 	БазовыйПериодКонец);	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Ошибки = Неопределено;
	
	// Определение по методу расчета- как будет получена база
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если КоличествоМесяцев = 0 Тогда
			Прервать;
		КонецЕсли;	
		
		Если НеполныеМесяцы = ПредопределенноеЗначение("Перечисление.НеполныеМесяцы.Отбрасывать") Тогда 
			// 1. Если выбран метод "Отбрасывать" - 
			// то все не полностью отработанные месяцы не будут учитываться.		
			Если НЕ ВыборкаДетальныеЗаписи.ОтработаноДней = ВыборкаДетальныеЗаписи.НормаДней Тогда 
				Продолжить;
			КонецЕсли;	
			
			СтрокаТабличнойЧасти = СреднийЗаработок.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыборкаДетальныеЗаписи); 
		ИначеЕсли НеполныеМесяцы = ПредопределенноеЗначение("Перечисление.НеполныеМесяцы.Дополнять") Тогда	
			// 2. Если выбран метод "Дополнять" - 
			// то по полученным данным в месяце 
			// расчет ежедневного дохода и дополнение до полного месяца.
			СтрокаТабличнойЧасти = СреднийЗаработок.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыборкаДетальныеЗаписи); 
			
			Если ВыборкаДетальныеЗаписи.ОтработаноДней > 0 И
				НЕ СтрокаТабличнойЧасти.ОтработаноДней = СтрокаТабличнойЧасти.НормаДней Тогда 
				СтрокаТабличнойЧасти.Результат = СтрокаТабличнойЧасти.Результат / СтрокаТабличнойЧасти.ОтработаноДней * СтрокаТабличнойЧасти.НормаДней;			
			КонецЕсли;	
		ИначеЕсли НеполныеМесяцы = ПредопределенноеЗначение("Перечисление.НеполныеМесяцы.НеИзменять") Тогда	
			// 3. Если выбран метод "Не изменять" - то ничего не менять.	
			СтрокаТабличнойЧасти = СреднийЗаработок.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыборкаДетальныеЗаписи); 
		КонецЕсли;	
		
		КоличествоМесяцев = КоличествоМесяцев - 1;
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	
	// Подготовка наборов записей
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	БухгалтерскийУчетСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	СреднийЗаработок.Сортировать("ПериодРегистрации");
	
КонецПроцедуры // ЗаполнитьТабличнуюЧасть()

// Процедура рассчитывает табличную часть
//
Процедура РассчитатьТабличнуюЧасть(РазмерСреднийЗаработок) Экспорт

	// Получение размеров для расчета БЛ
	РазмерыБольничных = ПроведениеРасчетовПоЗарплатеСервер.РазмерыБольничныхЛистов(КоличествоЛетСтажа);
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ДанныеПроизводственногоКалендаря.ГрафикРаботы КАК ГрафикРаботы,
		|	ДанныеПроизводственногоКалендаря.Дата КАК Дата,
		|	ДанныеПроизводственногоКалендаря.ВидДня КАК ВидДня
		|ПОМЕСТИТЬ ВременнаяТаблицаДанныеПроизводственногоКалендаря
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|ГДЕ
		|	ДанныеПроизводственногоКалендаря.ГрафикРаботы = &ГрафикРаботы
		|	И (ДанныеПроизводственногоКалендаря.Год = &ГодНачалоПериода
		|			ИЛИ ДанныеПроизводственногоКалендаря.Год = &ГодКонецПериода)
		|	И ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &НачалоПериода И КОНЕЦПЕРИОДА(&КонецПериода, МЕСЯЦ)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 10
		|	ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата КАК Дата,
		|	НАЧАЛОПЕРИОДА(ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ) КАК ПериодРегистрации
		|ПОМЕСТИТЬ ВременнаяТаблицаДниОрганизации
		|ИЗ
		|	ВременнаяТаблицаДанныеПроизводственногоКалендаря КАК ВременнаяТаблицаДанныеПроизводственногоКалендаря
		|ГДЕ
		|	(ВременнаяТаблицаДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий)
		|			ИЛИ ВременнаяТаблицаДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата КАК Дата
		|ПОМЕСТИТЬ ВременнаяТаблицаДниОрганизацииКалендарные
		|ИЗ
		|	ВременнаяТаблицаДанныеПроизводственногоКалендаря КАК ВременнаяТаблицаДанныеПроизводственногоКалендаря
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаДниОрганизации КАК ВременнаяТаблицаДниОрганизации
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата <= ВременнаяТаблицаДниОрганизации.Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата КАК Дата,
		|	НАЧАЛОПЕРИОДА(ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ) КАК ПериодРегистрации
		|ПОМЕСТИТЬ ВременнаяТаблицаДниСФ
		|ИЗ
		|	ВременнаяТаблицаДанныеПроизводственногоКалендаря КАК ВременнаяТаблицаДанныеПроизводственногоКалендаря
		|ГДЕ
		|	НЕ ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата В
		|				(ВЫБРАТЬ
		|					ВременнаяТаблицаДниОрганизации.Дата
		|				ИЗ
		|					ВременнаяТаблицаДниОрганизации КАК ВременнаяТаблицаДниОрганизации)
		|	И (ВременнаяТаблицаДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий)
		|			ИЛИ ВременнаяТаблицаДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный))
		|	И ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата <= &КонецПериода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата КАК Дата,
		|	НАЧАЛОПЕРИОДА(ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ) КАК ПериодРегистрации
		|ПОМЕСТИТЬ ВременнаяТаблицаДниСФКалендарные
		|ИЗ
		|	ВременнаяТаблицаДанныеПроизводственногоКалендаря КАК ВременнаяТаблицаДанныеПроизводственногоКалендаря
		|ГДЕ
		|	НЕ ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата В
		|				(ВЫБРАТЬ
		|					ВременнаяТаблицаДниОрганизацииКалендарные.Дата
		|				ИЗ
		|					ВременнаяТаблицаДниОрганизацииКалендарные КАК ВременнаяТаблицаДниОрганизацииКалендарные)
		|	И ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата <= &КонецПериода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МИНИМУМ(ВременнаяТаблицаДниОрганизации.Дата) КАК ДатаНачала,
		|	МАКСИМУМ(ВременнаяТаблицаДниОрганизации.Дата) КАК ДатаОкончания
		|ПОМЕСТИТЬ ВременнаяТаблицаПериодыОрганизации
		|ИЗ
		|	ВременнаяТаблицаДниОрганизации КАК ВременнаяТаблицаДниОрганизации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МИНИМУМ(ВременнаяТаблицаДниСФКалендарные.Дата) КАК ДатаНачала,
		|	МАКСИМУМ(ВременнаяТаблицаДниСФКалендарные.Дата) КАК ДатаОкончания
		|ПОМЕСТИТЬ ВременнаяТаблицаПериодыСФ
		|ИЗ
		|	ВременнаяТаблицаДниСФКалендарные КАК ВременнаяТаблицаДниСФКалендарные
		|ГДЕ
		|	ВременнаяТаблицаДниСФКалендарные.Дата <= &КонецПериода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ) КАК ПериодРегистрации,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата) КАК НормаДней
		|ПОМЕСТИТЬ ВременнаяТаблицаНормаДней
		|ИЗ
		|	ВременнаяТаблицаДанныеПроизводственногоКалендаря КАК ВременнаяТаблицаДанныеПроизводственногоКалендаря
		|ГДЕ
		|	(ВременнаяТаблицаДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий)
		|			ИЛИ ВременнаяТаблицаДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный))
		|
		|СГРУППИРОВАТЬ ПО
		|	НАЧАЛОПЕРИОДА(ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	""За счет организации"" КАК Пояснение,
		|	ВременнаяТаблицаДни.ПериодРегистрации КАК ПериодРегистрации,
		|	&ВидРасчетаОрганизация КАК ВидРасчета,
		|	&РазмерЗаСчетОрганизации КАК Размер,
		|	ВЫБОР
		|		КОГДА &ПособиеПоБеременности
		|			ТОГДА &РазмерЗаСчетОрганизации * КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВременнаяТаблицаДни.Дата) * &ПроцентБеременность / 100
		|		ИНАЧЕ &РазмерЗаСчетОрганизации * КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВременнаяТаблицаДни.Дата) * &Процент / 100
		|	КОНЕЦ КАК Результат,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВременнаяТаблицаДни.Дата) КАК ОтработаноДней,
		|	ВЫБОР
		|		КОГДА НАЧАЛОПЕРИОДА(&НачалоПериода, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|				И &НачалоПериода <= ТаблицаПериоды.ДатаНачала
		|			ТОГДА &НачалоПериода
		|		КОГДА НАЧАЛОПЕРИОДА(ТаблицаПериоды.ДатаНачала, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|			ТОГДА ТаблицаПериоды.ДатаНачала
		|		ИНАЧЕ НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|	КОНЕЦ КАК ДатаНачала,
		|	ВЫБОР
		|		КОГДА НАЧАЛОПЕРИОДА(&КонецПериода, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|				И &КонецПериода <= ТаблицаПериоды.ДатаОкончания
		|			ТОГДА &КонецПериода
		|		КОГДА НАЧАЛОПЕРИОДА(ТаблицаПериоды.ДатаОкончания, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|			ТОГДА ТаблицаПериоды.ДатаОкончания
		|		ИНАЧЕ КОНЕЦПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|	КОНЕЦ КАК ДатаОкончания
		|ИЗ
		|	ВременнаяТаблицаПериодыОрганизации КАК ТаблицаПериоды
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаДниОрганизации КАК ВременнаяТаблицаДни
		|		ПО (ИСТИНА)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаДни.ПериодРегистрации,
		|	ВЫБОР
		|		КОГДА НАЧАЛОПЕРИОДА(&НачалоПериода, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|				И &НачалоПериода <= ТаблицаПериоды.ДатаНачала
		|			ТОГДА &НачалоПериода
		|		КОГДА НАЧАЛОПЕРИОДА(ТаблицаПериоды.ДатаНачала, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|			ТОГДА ТаблицаПериоды.ДатаНачала
		|		ИНАЧЕ НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА НАЧАЛОПЕРИОДА(&КонецПериода, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|				И &КонецПериода <= ТаблицаПериоды.ДатаОкончания
		|			ТОГДА &КонецПериода
		|		КОГДА НАЧАЛОПЕРИОДА(ТаблицаПериоды.ДатаОкончания, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|			ТОГДА ТаблицаПериоды.ДатаОкончания
		|		ИНАЧЕ КОНЕЦПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|	КОНЕЦ
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	""За счет СФ"",
		|	ВременнаяТаблицаДни.ПериодРегистрации,
		|	&ВидРасчетаСФ,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаНормаДней.НормаДней = 0
		|			ТОГДА 0
		|		ИНАЧЕ &РазмерЗаСчетСФ / ВременнаяТаблицаНормаДней.НормаДней
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА &ПособиеПоБеременности
		|			ТОГДА ВЫБОР
		|					КОГДА ВременнаяТаблицаНормаДней.НормаДней = 0
		|						ТОГДА 0
		|					ИНАЧЕ &РазмерБеременностьЗаСчетСФ / ВременнаяТаблицаНормаДней.НормаДней * КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВременнаяТаблицаДни.Дата)
		|				КОНЕЦ
		|		ИНАЧЕ ВЫБОР
		|				КОГДА ВременнаяТаблицаНормаДней.НормаДней = 0
		|					ТОГДА 0
		|				ИНАЧЕ &РазмерЗаСчетСФ / ВременнаяТаблицаНормаДней.НормаДней * КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВременнаяТаблицаДни.Дата)
		|			КОНЕЦ
		|	КОНЕЦ,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВременнаяТаблицаДни.Дата),
		|	ВЫБОР
		|		КОГДА НАЧАЛОПЕРИОДА(ТаблицаПериоды.ДатаНачала, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|			ТОГДА ТаблицаПериоды.ДатаНачала
		|		ИНАЧЕ НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА НАЧАЛОПЕРИОДА(&КонецПериода, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|				И &КонецПериода <= ТаблицаПериоды.ДатаОкончания
		|			ТОГДА &КонецПериода
		|		КОГДА НАЧАЛОПЕРИОДА(ТаблицаПериоды.ДатаОкончания, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|			ТОГДА ТаблицаПериоды.ДатаОкончания
		|		ИНАЧЕ КОНЕЦПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|	КОНЕЦ
		|ИЗ
		|	ВременнаяТаблицаПериодыСФ КАК ТаблицаПериоды
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаДниСФ КАК ВременнаяТаблицаДни
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаНормаДней КАК ВременнаяТаблицаНормаДней
		|			ПО ВременнаяТаблицаДни.ПериодРегистрации = ВременнаяТаблицаНормаДней.ПериодРегистрации
		|		ПО (ИСТИНА),
		|	ВременнаяТаблицаДниОрганизации КАК ВременнаяТаблицаДниОрганизации
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаДни.ПериодРегистрации,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаНормаДней.НормаДней = 0
		|			ТОГДА 0
		|		ИНАЧЕ &РазмерЗаСчетСФ / ВременнаяТаблицаНормаДней.НормаДней
		|	КОНЕЦ,
		|	ВременнаяТаблицаНормаДней.НормаДней,
		|	ВЫБОР
		|		КОГДА НАЧАЛОПЕРИОДА(ТаблицаПериоды.ДатаНачала, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|			ТОГДА ТаблицаПериоды.ДатаНачала
		|		ИНАЧЕ НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА НАЧАЛОПЕРИОДА(&КонецПериода, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|				И &КонецПериода <= ТаблицаПериоды.ДатаОкончания
		|			ТОГДА &КонецПериода
		|		КОГДА НАЧАЛОПЕРИОДА(ТаблицаПериоды.ДатаОкончания, МЕСЯЦ) = НАЧАЛОПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|			ТОГДА ТаблицаПериоды.ДатаОкончания
		|		ИНАЧЕ КОНЕЦПЕРИОДА(ВременнаяТаблицаДни.Дата, МЕСЯЦ)
		|	КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачала,
		|	ДатаОкончания";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВЫБРАТЬ ПЕРВЫЕ 10", "ВЫБРАТЬ ПЕРВЫЕ " + РазмерыБольничных.ДнейОрганизации);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ГодНачалоПериода", Год(ДатаНачала));
	Запрос.УстановитьПараметр("ГодКонецПериода", Год(ДатаОкончания));
	Запрос.УстановитьПараметр("НачалоПериода", ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ДатаОкончания);
	Запрос.УстановитьПараметр("РазмерЗаСчетОрганизации", РазмерСреднийЗаработок);
	Запрос.УстановитьПараметр("ВидРасчетаОрганизация", МетодРасчета.ВидРасчетаОрганизация);
	Запрос.УстановитьПараметр("ВидРасчетаСФ", МетодРасчета.ВидРасчетаСФ);
	Запрос.УстановитьПараметр("ГрафикРаботы", ГрафикРаботы);
	Запрос.УстановитьПараметр("ПособиеПоБеременности", МетодРасчета = Справочники.МетодыРасчетаБольничногоЛиста.ПособиеПоБеременности);
	
	Запрос.УстановитьПараметр("ПроцентБеременность", РазмерыБольничных.ПроцентБеременность);
	Запрос.УстановитьПараметр("Процент", РазмерыБольничных.Процент); // Процент оплаты организацией
	Запрос.УстановитьПараметр("РазмерЗаСчетСФ",РазмерыБольничных.РазмерЗаСчетСФ);
	Запрос.УстановитьПараметр("РазмерБеременностьЗаСчетСФ", РазмерыБольничных.РазмерБеременностьЗаСчетСФ);
	
	Начисления.Загрузить(Запрос.Выполнить().Выгрузить());

	СтруктураОтбора = ПроведениеРасчетовПоЗарплатеСервер.СтруктураОтбораДанныхСчетовУчетаПоЗП();

	// Определение счетов учета
	Для Каждого СтрокаТабличнойЧасти Из Начисления Цикл 
		ЗаполнитьЗначенияСвойств(СтруктураОтбора, СтрокаТабличнойЧасти);
		СтруктураОтбора.Подразделение = Подразделение;
		СтруктураОтбора.ВидРасчетаНачисления = СтрокаТабличнойЧасти.ВидРасчета;
		
		ДанныеСчетаУчетаЗП = ПроведениеРасчетовПоЗарплатеСервер.ДанныеСчетаУчетаЗП(СтруктураОтбора);
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеСчетаУчетаЗП);		
	КонецЦикла;	
КонецПроцедуры

// Выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ЗаполнениеОбъектов.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	БухгалтерскийУчетСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.БольничныйЛист.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	БухгалтерскийУчетСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	БухгалтерскийУчетСервер.ОтразитьНачисления(ДополнительныеСвойства, Движения, Отказ);
	БухгалтерскийУчетСервер.ОтразитьВзаиморасчетыССотрудниками(ДополнительныеСвойства, Движения, Отказ);
	
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
		
КонецПроцедуры

// В обработчике события ОбработкаПроверкиЗаполнения документа выполняется
// копирование и обнуление проверяемых реквизитов для исключения стандартной
// проверки заполнения платформой и последующей проверки средствами встроенного языка.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ПроверяемыеРеквизиты.Добавить("Начисления");
	
	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#КонецЕсли