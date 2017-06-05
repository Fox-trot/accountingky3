﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСерия				= НСтр("ru = '%1'");
	ТекстНомер				= НСтр("ru = ', № %1'");
	ТекстДатаВыдачи			= НСтр("ru = ', выдан: %1'");
	ТекстСрокДействия		= НСтр("ru = ', действует до: %1'");
	ТекстКодПодразделения	= НСтр("ru = ', № подр. %1'");
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Запись.ВидДокумента.Пустая() Тогда
			Запись.Представление = "";
			
		Иначе
			Запись.Представление = ""
				//+ Запись.ВидДокумента
				+ ?(ЗначениеЗаполнено(Запись.Серия), СтрШаблон(ТекстСерия, Запись.Серия), "")
				+ ?(ЗначениеЗаполнено(Запись.Номер), СтрШаблон(ТекстНомер, Запись.Номер), "")
				+ ?(ЗначениеЗаполнено(Запись.ДатаВыдачи), СтрШаблон(ТекстДатаВыдачи, Формат(Запись.ДатаВыдачи,"ДФ='dd.MM.yyyy"" г.""'")), "")
				+ ?(ЗначениеЗаполнено(Запись.СрокДействия), СтрШаблон(ТекстСрокДействия, Формат(Запись.СрокДействия,"ДФ='dd.MM.yyyy"" г.""'")), "")
				+ ?(ЗначениеЗаполнено(Запись.КемВыдан), ", " + Запись.КемВыдан, "")
				+ ?(ЗначениеЗаполнено(Запись.КодПодразделения) И Запись.ВидДокумента = Справочники.ВидыДокументовФизическихЛиц.Паспорт, СтрШаблон(ТекстКодПодразделения, Запись.КодПодразделения), "");
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаДокументов",	Выгрузить(, "Физлицо, Период, ЯвляетсяДокументомУдостоверяющимЛичность"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокументов.Физлицо КАК Физлицо,
	|	ТаблицаДокументов.Период КАК Период
	|ПОМЕСТИТЬ ВременнаяТаблицаДокументы
	|ИЗ
	|	&ТаблицаДокументов КАК ТаблицаДокументов
	|ГДЕ
	|	ТаблицаДокументов.ЯвляетсяДокументомУдостоверяющимЛичность
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Физлицо,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументыФизическихЛиц.Физлицо КАК Физлицо,
	|	ДокументыФизическихЛиц.Период КАК Период,
	|	КОЛИЧЕСТВО(ДокументыФизическихЛиц.Физлицо) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаДокументы КАК ДокументыСрез
	|		ПО ДокументыФизическихЛиц.Период = ДокументыСрез.Период
	|			И ДокументыФизическихЛиц.Физлицо = ДокументыСрез.Физлицо
	|			И (ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокументыФизическихЛиц.Физлицо,
	|	ДокументыФизическихЛиц.Период
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ДокументыФизическихЛиц.Физлицо) > 1";
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТекстСообщения = НСтр("ru = 'На %1 у физлица %2 уже введен документ, удостоверяющий личность.'");
	
	Пока Выборка.Следующий() Цикл
		Отказ = Истина;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(ТекстСообщения, Формат(Выборка.Период, "ДЛФ=D"), Выборка.Физлицо));
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли