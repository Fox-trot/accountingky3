﻿
#Область ПроцедурыОбработчикиСобытийФормы

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьПредставлениеВсехСтрок();
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийТабличнойЧасти

// Процедура - обработчик события "ПриОкончанииРедактирования" строки в ТЧ "ШкалаОценкиСтоимости".
//
&НаКлиенте
Процедура ШкалаОценкиСтоимостиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	// После ввода строки отсортируем ТЧ по возрастанию нижней границы.
	Объект.ШкалаОценкиСтоимости.Сортировать("НижняяГраница");
	ОбновитьПредставлениеВсехСтрок();
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" для колонки "НижняяГраница" строки в ТЧ "ШкалаОценкиСтоимости".
//
&НаКлиенте
Процедура ШкалаОценкиСтоимостиНижняяГраницаПриИзменении(Элемент)
	
	ТекСтрЭлемент = Элементы.ШкалаОценкиСтоимости.ТекущиеДанные;
	ТекСтрЭлемент.ПредставлениеИнтервала = ПолучитьПредставлениеИнтервала(Объект.ШкалаОценкиСтоимости, ТекСтрЭлемент);
	
КонецПроцедуры

// Процедура - обработчик события "ПослеУдаления" ТЧ "ШкалаОценкиСтоимости".
//
&НаКлиенте
Процедура ШкалаОценкиСтоимостиПослеУдаления(Элемент)
	
	ОбновитьПредставлениеВсехСтрок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
// Возвращает текстовое представление интервала.
//
Функция ПолучитьПредставлениеИнтервала(ТабличнаяЧасть, ТекущаяСтрока)

	МаксНижняяГраница = Неопределено;
	СледующаяСтрока = Неопределено;
	Для Каждого СтрокаТЧ Из ТабличнаяЧасть Цикл
		Если (МаксНижняяГраница = Неопределено Или МаксНижняяГраница >= СтрокаТЧ.НижняяГраница)
		   И ТекущаяСтрока.НижняяГраница <= СтрокаТЧ.НижняяГраница
		   И СтрокаТЧ <> ТекущаяСтрока Тогда
			СледующаяСтрока = СтрокаТЧ;
			МаксНижняяГраница = СтрокаТЧ.НижняяГраница;
		КонецЕсли;
	КонецЦикла;

	Если СледующаяСтрока = Неопределено Тогда
		ПредставлениеИнтервала = СтрШаблон(НСтр("ru = 'От %1'"), СокрЛП(ТекущаяСтрока.НижняяГраница));
	ИначеЕсли ТекущаяСтрока.НижняяГраница = СледующаяСтрока.НижняяГраница Тогда
		ПредставлениеИнтервала = НСтр("ru = 'ОШИБКА: такая нижняя граница уже есть.'");
	Иначе
		ПредставлениеИнтервала = СтрШаблон(НСтр("ru = 'От %1 до %2'"), 
									СокрЛП(ТекущаяСтрока.НижняяГраница), 
									СокрЛП(СледующаяСтрока.НижняяГраница));
	КонецЕсли;

	Возврат ПредставлениеИнтервала;

КонецФункции // ПолучитьПредставлениеИнтервала()

// Процедура обновляет значение в колонке ПредставлениеИнтервала табличной части ШкалаОценкиСтоимости.
//
&НаКлиенте
Процедура ОбновитьПредставлениеВсехСтрок()

	Для каждого ТекСтр Из Объект.ШкалаОценкиСтоимости Цикл
		ТекСтр.ПредставлениеИнтервала = ПолучитьПредставлениеИнтервала(Объект.ШкалаОценкиСтоимости, ТекСтр);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти