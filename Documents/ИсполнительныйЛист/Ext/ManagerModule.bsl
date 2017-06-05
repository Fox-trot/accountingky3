﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаПлановыеУдержания(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.ДатаНачала КАК Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	ВременнаяТаблицаШапка.ВидРасчета,
		|	ВременнаяТаблицаШапка.Ссылка КАК ДокументСсылка,
		|	ВременнаяТаблицаШапка.СуммаДокумента КАК Размер,
		|	ИСТИНА КАК Актуальность
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.ДатаОкончания,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.ФизЛицо,
		|	ВременнаяТаблицаШапка.ВидРасчета,
		|	ВременнаяТаблицаШапка.Ссылка,
		|	ВременнаяТаблицаШапка.СуммаДокумента,
		|	ЛОЖЬ
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка";
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлановыеУдержания", РезультатЗапроса.Выгрузить());
КонецПроцедуры // СформироватьТаблицаПлановыеНачисленияИУдержания()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИсполнительныйЛист.Ссылка,
	|	ИсполнительныйЛист.Дата,
	|	ИсполнительныйЛист.Организация,
	|	ИсполнительныйЛист.ФизЛицо,
	|	ИсполнительныйЛист.ВидРасчета,
	|	ИсполнительныйЛист.СуммаДокумента,
	|	ИсполнительныйЛист.ДатаНачала,
	|	ИсполнительныйЛист.ДатаОкончания
	|ПОМЕСТИТЬ ВременнаяТаблицаШапка
	|ИЗ
	|	Документ.ИсполнительныйЛист КАК ИсполнительныйЛист
	|ГДЕ
	|	ИсполнительныйЛист.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаПлановыеУдержания(ДокументСсылка, СтруктураДополнительныеСвойства);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#КонецЕсли