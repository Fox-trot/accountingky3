﻿#Область ОбработчикиСобытийЭлементовШапкиФормы
// Процедура - обработчик события ПриИзменении поля ввода ВидДокумента.
//
&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	Если ЯвляетсяУдостоверениемЛичности(Запись.ФизЛицо, Запись.ВидДокумента, Запись.Период) Тогда
		Запись.ЯвляетсяДокументомУдостоверяющимЛичность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЯвляетсяУдостоверениемЛичности(ФизЛицо, ВидДокумента, Дата)
	
	Возврат РегистрыСведений.ДокументыФизическихЛиц.ЯвляетсяУдостоверениемЛичности(ФизЛицо, ВидДокумента, Дата);
	
КонецФункции

#КонецОбласти

