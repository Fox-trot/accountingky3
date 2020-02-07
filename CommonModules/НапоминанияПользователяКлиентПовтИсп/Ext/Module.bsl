﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Выполняет запрос по напоминаниям для текущего пользователя на 30 минут вперед от текущего времени.
// Момент времени смещен от текущего для того, чтобы данные были актуальны в течение жизни кэша.
// При обработке результата выполнения функции необходимо учитывать эту особенность.
//
// ФиксированныйМассив в возвращаемом значении не используется, так как кэшированный результат функции необходимо модифицировать
// на клиенте. Такой подход применяется для минимизации серверных вызовов.
//
// Возвращаемое значение:
//  см. НапоминанияПользователяСлужебный.СписокТекущихНапоминанийПользователя
//
Функция ПолучитьНапоминанияТекущегоПользователя() Экспорт
	
	Возврат НапоминанияПользователяВызовСервера.ПолучитьНапоминанияТекущегоПользователя();
	
КонецФункции

#КонецОбласти
