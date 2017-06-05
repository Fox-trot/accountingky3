﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура создает пустую временную таблицу изменения движений.
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	Запасы.НомерСтроки КАК НомерСтроки,
	|	Запасы.Организация КАК Организация,
	|	Запасы.Склад КАК Склад,
	|	Запасы.СчетУчета КАК СчетУчета,
	|	Запасы.Номенклатура КАК Номенклатура,
	|	Запасы.Партия КАК Партия,
	|	Запасы.Количество КАК КоличествоПередЗаписью,
	|	Запасы.Количество КАК КоличествоИзменение,
	|	Запасы.Количество КАК КоличествоПриЗаписи,
	|	Запасы.Сумма КАК СуммаПередЗаписью,
	|	Запасы.Сумма КАК СуммаИзменение,
	|	Запасы.Сумма КАК СуммаПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыИзменение
	|ИЗ
	|	РегистрНакопления.Запасы КАК Запасы");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()

#КонецОбласти

#КонецЕсли